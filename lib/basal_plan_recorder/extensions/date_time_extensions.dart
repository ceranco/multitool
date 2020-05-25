extension DateTimeExtensions on DateTime {
  String get dmy =>
      '${this.day.toPaddedString()}/${this.month.toPaddedString()}/${this.year}';

  String get hms =>
      '${this.hour.toPaddedString()}:${this.minute.toPaddedString()}:${this.second.toPaddedString()}';

  String get dmyHms => '$dmy $hms';
}

extension _IntExtensions on int {
  String toPaddedString() => this.toString().padLeft(2, '0');
}
