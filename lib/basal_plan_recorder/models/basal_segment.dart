import 'package:flutter/foundation.dart';
import 'package:multitool/basal_plan_recorder/models/basal_time.dart';

/// Defines a segment of time with an associated basal rate.
///
/// [end] must be greater than [start] (`start < end == true`).
@immutable
class BasalSegment {
  /// The time at which the segments begins.
  final BasalTime start;

  /// The time at which the segment ends.
  final BasalTime end;

  /// The basal rate during the segment.
  final double basalRate;

  const BasalSegment({
    @required this.start,
    @required this.end,
    @required this.basalRate,
  }) : assert(start < end);
}
