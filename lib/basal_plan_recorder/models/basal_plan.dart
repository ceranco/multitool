import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:multitool/basal_plan_recorder/models/basal_segment.dart';
import 'package:multitool/basal_plan_recorder/models/basal_time.dart';
import 'package:multitool/exceptions/exceptions.dart';

/// Represents a full **valid** basal plan.
///
/// All operations ([add], [removeAt] and [replaceAt]) are done in a way that ensures that ensuing state
/// will remain valid.
///
/// To be valid, a plan must have the following properties:
/// * Have at least **one** segment.
/// * The segment(s) must **continuously** span the whole day [(00:00)..(24:00)]
/// * The segments must **not** overlap.
class BasalPlan extends ChangeNotifier {
  List<BasalSegment> _segments;

  /// The [DateTime] at which the plan was created.
  DateTime created;

  /// A read-only view of the plan's basal segments.
  UnmodifiableListView<BasalSegment> get segments =>
      UnmodifiableListView(_segments);

  /// Creates a new instance with **one** segment with a
  /// default basal rate (1.0) and the current time [DateTime.now()].
  BasalPlan()
      : _segments = [
          BasalSegment(
            start: BasalTime.earliest,
            end: BasalTime.latest,
            basalRate: 1.0,
          ),
        ],
        created = DateTime.now();

  /// Creates a new copied instance of the plan.
  ///
  /// This is useful for making comparisons after editing operations.
  BasalPlan.copy(BasalPlan other)
      : _segments = List.from(other._segments),
        created = other.created;

  // TODO: add assert that verifies that the plan is valid.
  /// Creates a new instance from json data.
  BasalPlan.fromJson(Map<String, dynamic> data)
      : _segments = [
          for (var segmentData in data['segments'])
            BasalSegment.fromJson(segmentData)
        ],
        created = (data['created'] as Timestamp).toDate();

  /// Returns the json representation of this instance.
  Map<String, dynamic> get json => {
        'segments': [for (var segment in _segments) segment.json],
        'created': Timestamp.fromDate(created),
      };

  @override
  operator ==(Object other) =>
      other is BasalPlan &&
      listEquals(other._segments, _segments) &&
      other.created == created;

  @override
  int get hashCode {
    int hash = 23;
    hash = hash * 31 + _segments.hashCode;
    hash = hash * 31 + created.hashCode;
    return hash;
  }

  /// Returns the total basal units per a single day.
  double get totalBasal => _segments.fold(0, (total, segment) {
        final durationTime = BasalTime.decode(
          segment.end.asEncoded - segment.start.asEncoded,
        );
        final duration = durationTime.hour + durationTime.minute / 60;

        return total + duration * segment.basalRate;
      });

  /// Adds a new segment to the plan.
  ///
  /// Behaves as follows:
  /// * If new segment overlaps with another, the other
  ///   segment is shrunk accordingly.
  /// * If new segment is completely contained in another, the other
  ///   segment is split and both parts are shrunk.
  /// * If new segment completely contains another, the other
  ///   segment is discarded.
  void add(BasalSegment segment) {
    // Find all segments which 'touch' the new segment
    final Map<int, BasalSegmentRelationship> relationships = _segments
        .asMap()
        .map((index, s) => MapEntry(
              index,
              segment.calculateRelationship(s),
            ))
          ..removeWhere((_, relationship) =>
              relationship == BasalSegmentRelationship.after ||
              relationship == BasalSegmentRelationship.before);

    // Go over each segment which interacts with the new segment and
    // edit it accordingly
    bool added = false; // make sure we add the segment **once**

    // This must be bumped when adding / removing new segments to the map,
    // to ensure that ensuing relationships can be handled correctly.
    // This works because we iterate over the relationships from beginning to end.
    int indexOffset = 0;
    for (var entry in relationships.entries) {
      final index = entry.key + indexOffset;
      final relationship = entry.value;

      if (relationship == BasalSegmentRelationship.afterOverlap) {
        // shrink the segment
        final overlappedSegment = _segments[index];
        _segments[index] = overlappedSegment.copyWith(end: segment.start);

        // add the new segment
        if (!added) {
          added = true;
          _segments.insert(index + 1, segment);
          indexOffset++;
        }
      } else if (relationship == BasalSegmentRelationship.beforeOverlap) {
        // shrink the segment
        final overlappedSegment = _segments[index];
        _segments[index] = overlappedSegment.copyWith(start: segment.end);

        // add the new segment
        if (!added) {
          added = true;
          _segments.insert(index, segment);
          indexOffset++;
        }
      } else if (relationship == BasalSegmentRelationship.contains) {
        // remove the segment
        _segments.removeAt(index);

        // add the new segment
        if (!added) {
          added = true;
          _segments.insert(index, segment);
        } else {
          // If we removed the segment without adding another (because
          // it was already added), we must decrement the offset.
          indexOffset--;
        }
      } else if (relationship == BasalSegmentRelationship.contained) {
        // This case should only occur when there is a single relationship,
        // as the existing segment contains the new segment.
        // As such, there is no need to set the `added` flag or bump the `indexOffset`.

        // split the segment
        final containingSegment = _segments[index];
        int addIndex = index;

        // First we remove the existing segment so that we can use simple
        // `.insert`s.
        _segments.removeAt(index);

        // The first part of the split is only needed if the new
        // segment doesn't start at the same point as the existing segment.
        if (segment.start != containingSegment.start) {
          _segments.insert(
            addIndex++,
            containingSegment.copyWith(
              end: segment.start,
            ),
          ); // the first part of the split
        }

        _segments.insert(addIndex++, segment); // the new segment

        // The second part of the split is only needed if the new
        // segment doesn't end at the same point as the existing segment.
        if (segment.end != containingSegment.end) {
          _segments.insert(
            addIndex,
            containingSegment.copyWith(start: segment.end),
          ); // the second part of the split
        }
      } else if (relationship == BasalSegmentRelationship.match) {
        _segments[index] = segment;
      }
    }
    notifyListeners();
  }

  /// Removes the segment at the given index.
  ///
  /// Behaves as follows:
  /// * If removed segment is not last, the following segment
  ///   will be expanded to fill the gap.
  /// * If removed segment is last, the previous segment
  ///   will be expanded to fill the gap.
  /// * If no other segments will remain, throws an [InvalidOperationException]
  void removeAt(int index) {
    // index must be in range
    assert(0 <= index && index < segments.length);

    // Ensure that there will be at least one remaining segment.
    if (_segments.length == 1) {
      throw new InvalidOperationException(
        'At least one segment must remain for a BasalPlan to be valid',
      );
    }

    // Save the segment to use when expanding the other ones.
    final removedSegment = _segments[index];

    // We need to expand the previous segment only if the last
    // segment is removed.
    if (index == _segments.length - 1) {
      final segmentToExpand = _segments[index - 1];
      _segments[index - 1] = segmentToExpand.copyWith(
        end: removedSegment.end,
      );
    }
    // Otherwise, we expand the following segment.
    else {
      final segmentToExpand = _segments[index + 1];
      _segments[index + 1] = segmentToExpand.copyWith(
        start: removedSegment.start,
      );
    }

    // Remove the segment after the changes to ensure that
    // the index remains correct.
    _segments.removeAt(index);

    notifyListeners();
  }

  /// Replaces the segment at the given index.
  ///
  /// Behaves as follows:
  /// * If `index == 0`, [segment.start] must equal [BasalTime.earliest],
  ///   otherwise throws [InvalidOperationException].
  /// * If `index == segments.length - 1`, [segment.end] must equal [BasalTime.latest],
  ///   otherwise throws [InvalidOperationException].
  /// * If `segments.length == 1`, simply replaces the segment.
  /// * Otherwise, calls [removeAt(index)] and then [add(segment)].
  void replaceAt(int index, BasalSegment segment) {
    // index must be in range
    assert(0 <= index && index < segments.length);

    // Ensure that if the first segment is replaced,
    // it begins at `BasalTime.earliest`.
    if (index == 0 && segment.start != BasalTime.earliest) {
      throw new InvalidOperationException(
        'The first segment must start at `BasalTime.earliest`',
      );
    }

    // Ensure that if the last segment is replaced,
    // it ends at `BasalTime.latest`.
    if (index == _segments.length - 1 && segment.end != BasalTime.latest) {
      throw new InvalidOperationException(
        'The first segment must end at `BasalTime.latest`',
      );
    }

    // When the plan contains a single segment, calling `removeAt` will
    // fail with an exception. As such, we handle it here (it is a simple case).
    if (segments.length == 1) {
      _segments[index] = segment;

      notifyListeners();
    } else {
      removeAt(index);
      add(segment);

      // `notifyListeners` isn't needed here as it is called in `removeAt` and `add`.
    }
  }
}
