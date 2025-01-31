import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:rubigo_router/rubigo_router.dart';

class RubigoBackGesture extends StatelessWidget {
  const RubigoBackGesture({
    required this.rubigoRouter,
    required this.allowBackGesture,
    required this.child,
    super.key,
  });

  final RubigoRouter rubigoRouter;
  final ValueNotifier<bool> allowBackGesture;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: allowBackGesture,
      builder: (context, allowBackGesture, child) {
        return PopScope(
          canPop: allowBackGesture,
          onPopInvokedWithResult: (didPop, result) {
            if (!didPop) {
              unawaited(rubigoRouter.ui.pop());
            }
          },
          child: child!,
        );
      },
      child: child,
    );
  }
}
