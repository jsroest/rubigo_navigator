import 'package:flutter/material.dart';
import 'package:rubigo_router/rubigo_router.dart';

/// Use this [Widget] in screens that do not uses the [RubigoScreenMixin].
/// It is used to wire up back navigation, like [BackButton].
class RubigoRouterPopScope extends StatelessWidget {
  /// Create a RubigoRouterPopScope
  const RubigoRouterPopScope({
    required this.rubigoRouter,
    required this.child,
    super.key,
  });

  /// The [RubigoRouter] that manages this screen.
  final RubigoRouter rubigoRouter;

  /// The widget below this widget in the tree.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) async {
        await rubigoRouter.pop(ignoreWhenBusy: true);
      },
      child: child,
    );
  }
}
