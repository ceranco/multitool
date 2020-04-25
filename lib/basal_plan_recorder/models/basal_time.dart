import 'package:flutter/foundation.dart';

/// A time of day in which a basal rate is defined.
///
/// [earliest] and [latest] define the two extremes of the possible time values.
@immutable
class BasalTime {
  /// The hour in the range of [0..24].
  final int hour;

  /// The minute in the range of [0..59].
  final int minute;

  /// The earliest possible value of [BasalTime].
  static const BasalTime earliest = BasalTime(hour: 0, minute: 0);

  /// The latest possible value of [BasalTime].
  static const BasalTime latest = BasalTime(hour: 24, minute: 0);

  const BasalTime({@required this.hour, @required this.minute})
      : assert(0 <= hour && hour <= 24),
        assert(0 <= minute && minute < 60);

  /// Returns a human-readable representation of the [BasalTime] in the `HH:MM` format.
  ///
  /// ```dart
  /// final time = BasalTime(hour: 5, minute: 2);
  /// print(time.format()); // <- '05:02'
  /// ```
  String format() =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padRight(2, '0')}';

  bool operator >(BasalTime other) =>
      hour > other.hour || hour == other.hour && minute > other.minute;

  bool operator >=(BasalTime other) => this == other || this > other;

  bool operator <=(BasalTime other) => this == other || this < other;

  bool operator <(BasalTime other) =>
      hour < other.hour || hour == other.hour && minute < other.minute;

  @override
  bool operator ==(Object other) =>
      other is BasalTime ? hour == other.hour && minute == other.minute : false;

  @override
  int get hashCode {
    int hash = 23;
    hash = hash * 31 + hour.hashCode;
    hash = hash * 31 + minute.hashCode;
    return hash;
  }
}
