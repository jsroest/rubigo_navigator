/// This exception is thrown when the last page is popped from the stack.
class LastPagePoppedException implements Exception {
  /// Creates a [LastPagePoppedException]
  LastPagePoppedException(this.message);

  /// A message to the developer.
  final String message;
}
