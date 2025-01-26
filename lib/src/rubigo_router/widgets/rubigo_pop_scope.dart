import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:rubigo_router/rubigo_router.dart';

/// Use this widget to disable the back gesture, but react on
/// - App back buttons
/// - Device back buttons
class RubigoPopScope extends StatelessWidget {
  /// Creates a RubigoPopScope
  const RubigoPopScope({
    required this.rubigoRouter,
    required this.child,
    super.key,
  });

  /// The controller that belongs to this screen
  final RubigoRouter rubigoRouter;

  /// The widget below this widget in the tree.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        unawaited(rubigoRouter.ui.pop());
      },
      child: child,
    );
  }
}
