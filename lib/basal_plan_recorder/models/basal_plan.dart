import 'dart:collection';

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
class BasalPlan {
  List<BasalSegment> _segments;

  /// A read-only view of the plan's basal segments.
  UnmodifiableListView<BasalSegment> get segments =>
      UnmodifiableListView(_segments);

  /// Creates a new instance with **one** segment with a default basal rate (1.0).
  BasalPlan()
      : _segments = [
          BasalSegment(
            start: BasalTime.earliest,
            end: BasalTime.latest,
            basalRate: 1.0,
          ),
        ];

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
  }

  /// Replaces the segment at the given index.
  ///
  /// Behaves as follows:
  /// * If `index == 0`, [segment.start] must equal [BasalTime.earliest],
  ///   otherwise throws [InvalidOperationException].
  /// * If `index == segments.length - 1`, [segment.end] must equal [BasalTime.latest],
  ///   otherwise throws [InvalidOperationException].
  /// * Calls [removeAt(index)] and then [add(segment)].
  void replaceAt(int index, BasalSegment segment) {}
}
