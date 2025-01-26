import 'package:rubigo_router/rubigo_router.dart';

/// This exception is thrown when the last page is popped from the stack.
/// It's used by [RubigoPopScope] to close the app on Android.
class LastPagePoppedException implements Exception {
  /// Creates a LastPagePoppedException
  LastPagePoppedException(this.message);

  /// A message to the developer.
  final String message;
}
