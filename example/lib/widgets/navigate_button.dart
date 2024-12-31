import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NavigateButton<SCREEN_ID extends Enum> extends StatelessWidget {
  const NavigateButton({
    required this.screenStackListener,
    required this.isEnabled,
    required this.onPressed,
    required this.child,
    super.key,
  });

  final ValueListenable<List<SCREEN_ID>> screenStackListener;
  final bool Function(List<Enum> screenStack) isEnabled;
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: screenStackListener,
      builder: (context, value, _) {
        return ElevatedButton(
          onPressed: isEnabled(screenStackListener.value) ? onPressed : null,
          child: child,
        );
      },
    );
  }
}
