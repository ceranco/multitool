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

  BasalSegment({
    @required this.start,
    @required this.end,
    @required this.basalRate,
  }) : assert(start < end);

  @override
  operator ==(Object other) =>
      other is BasalSegment &&
      start == other.start &&
      end == other.end &&
      basalRate == other.basalRate;

  @override
  int get hashCode {
    int hash = 23;
    hash = hash * 31 + start.hashCode;
    hash = hash * 31 + end.hashCode;
    hash = hash * 31 + basalRate.hashCode;
    return hash;
  }

  /// Calculates the relationship of this segment with another one.
  ///
  /// See [BasalSegmentRelationship] docs for more information.
  BasalSegmentRelationship calculateRelationship(BasalSegment other) {
    // Check if the segments match to ease further checks
    if (start == other.start && end == other.end) {
      return BasalSegmentRelationship.match;
    }

    // Can be one of the following: `before`, `beforeOverlap`, `contains`, `contained`
    if (start <= other.start) {
      if (start == other.start && end <= other.end) {
        return BasalSegmentRelationship.contained;
      } else if (end >= other.end) {
        return BasalSegmentRelationship.contains;
      } else if (end <= other.start) {
        return BasalSegmentRelationship.before;
      } else {
        return BasalSegmentRelationship.beforeOverlap;
      }
    }
    // Can be one of the following: `after`, `afterOverlap`, `contained`
    else {
      if (end <= other.end) {
        return BasalSegmentRelationship.contained;
      } else if (start >= other.end) {
        return BasalSegmentRelationship.after;
      } else
        return BasalSegmentRelationship.afterOverlap;
    }
  }

  /// Creates a new instance with the same values as this one, expect the specified changes.
  BasalSegment copyWith({BasalTime start, BasalTime end, double basalRate}) =>
      BasalSegment(
        start: start ?? this.start,
        end: end ?? this.end,
        basalRate: basalRate ?? this.basalRate,
      );
}

/// The possible relationships between different [BasalSegment]s.
enum BasalSegmentRelationship {
  /// The segment starts and ends before the other one starts.
  ///
  /// ```
  ///  segment 1
  /// |---------|
  ///               |----------|
  ///                 segment 2
  /// ```
  before,

  /// The segment starts and ends after the other one starts.
  ///
  /// ```
  ///                 segment 1
  ///               |----------|
  /// |---------|
  ///  segment 2
  /// ```
  after,

  /// The segment starts before the other one begins, and ends
  /// between the start and end of the other segment.
  /// ```
  ///  segment 1
  /// |---------|
  ///        |----------|
  ///          segment 2
  /// ```
  beforeOverlap,

  /// The segment starts between the start and end of the other one,
  /// and ends after the end of the other segment.
  /// ```
  ///          segment 1
  ///        |----------|
  /// |---------|
  ///  segment 2
  /// ```
  afterOverlap,

  /// The segment starts before the start of the other one,
  /// and ends after the end of the other segment.
  /// ```
  ///      segment 1
  /// |-----------------|
  ///     |---------|
  ///      segment 2
  /// ```
  contains,

  /// The segment starts and ends between the start and end of the other one.
  /// ```
  ///      segment 1
  ///     |---------|
  /// |-----------------|
  ///      segment 2
  /// ```
  contained,

  /// The segment starts and ends exactly where the other
  /// segment starts and ends.
  /// ```
  ///  segment 1
  /// |---------|
  /// |---------|
  ///  segment 2
  /// ```
  match,
}
