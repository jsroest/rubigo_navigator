import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NavigateButton extends StatelessWidget {
  const NavigateButton({
    required this.screenStackNotifier,
    required this.isEnabled,
    required this.onPressed,
    required this.child,
    super.key,
  });

  final ValueListenable<List<Enum>> screenStackNotifier;
  final bool Function(List<Enum> screenStack) isEnabled;
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: screenStackNotifier,
      builder: (context, value, _) {
        return ElevatedButton(
          onPressed: isEnabled(screenStackNotifier.value) ? onPressed : null,
          child: child,
        );
      },
    );
  }
}
