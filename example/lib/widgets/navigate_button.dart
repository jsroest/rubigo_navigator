import 'package:flutter/material.dart';
import 'package:rubigo_router/rubigo_router.dart';

// A button that rebuilds on screen stack changes. On rebuild it determines with
// the isEnabled functions if the button is enabled.
class NavigateButton<SCREEN_ID extends Enum> extends StatelessWidget {
  const NavigateButton({
    required this.rubigoRouter,
    required this.isEnabled,
    required this.onPressed,
    required this.child,
    super.key,
  });

  final RubigoRouter<SCREEN_ID> rubigoRouter;
  final bool Function(List<Enum> screenStack) isEnabled;
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: rubigoRouter,
      builder: (context, _) {
        return ElevatedButton(
          onPressed: isEnabled(rubigoRouter.screens.toListOfScreenId())
              ? onPressed
              : null,
          child: child,
        );
      },
    );
  }
}
