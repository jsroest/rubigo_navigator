import 'package:flutter/material.dart';
import 'package:rubigo_router/rubigo_router.dart';

/// Use this [Widget] in screens that uses the [RubigoScreenMixin].
/// It is used to wire up back navigation, like [BackButton].
class RubigoControllerPopScope extends StatelessWidget {
  /// Create a RubigoControllerPopScope
  const RubigoControllerPopScope({
    required this.controller,
    required this.child,
    super.key,
  });

  /// The controller that belongs to this page.
  final RubigoControllerMixin controller;

  /// The widget below this widget in the tree.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) async {
        if (controller.rubigoRouter.busyService.isBusy) {
          return;
        }
        await controller.rubigoRouter.busyService.busyWrapper(
          () async {
            if (await controller.mayPop()) {
              await controller.rubigoRouter.pop();
            }
          },
        );
      },
      child: child,
    );
  }
}
