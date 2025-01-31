import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:rubigo_router/rubigo_router.dart';

/// Use a RubigoBackGesture to control if a screen may be popped with a
/// back-gesture.
class RubigoBackGesture extends StatelessWidget {
  /// Creates a new RubigoBackGesture
  const RubigoBackGesture({
    required this.rubigoRouter,
    required this.allowBackGesture,
    required this.child,
    super.key,
  });

  /// The rubigoRouter to use
  final RubigoRouter rubigoRouter;

  /// allow or prevent back gestures
  final bool allowBackGesture;

  /// The widget below this widget in the tree.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: allowBackGesture,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          unawaited(rubigoRouter.ui.pop());
        }
      },
      child: child,
    );
  }
}
