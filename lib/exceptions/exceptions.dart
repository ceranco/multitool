class InvalidOperationException implements Exception {
  String cause;
  InvalidOperationException(this.cause);

  @override
  String toString() => 'InvalidOperationException: $cause';
}
