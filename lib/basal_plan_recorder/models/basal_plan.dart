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
  void add(BasalSegment segment) {}

  /// Removes the segment at the given index.
  ///
  /// Behaves as follows:
  /// * If removed segment is not last, the following segment
  ///   will be expanded to fill the gap.
  /// * If removed segment is last, the previous segment
  ///   will be expanded to fill the gap.
  /// * If no other segments will remain, throws an [InvalidOperationException]
  void removeAt(int index) {}

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
