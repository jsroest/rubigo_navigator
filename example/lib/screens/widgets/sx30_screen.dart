import 'package:example/screens/screens.dart';
import 'package:example/widgets/app_bar_title_breadcrumbs.dart';
import 'package:example/widgets/navigate_button.dart';
import 'package:flutter/material.dart';
import 'package:rubigo_router/rubigo_router.dart';

class Sx30Screen extends StatelessWidget {
  const Sx30Screen({
    required this.controller,
    required this.sX10Screen,
    required this.sX20Screen,
    required this.sX30Screen,
    required this.sX40Screen,
    required this.allowBackGesture,
    required this.backButtonAllowed,
    required this.onPushSx040ButtonPressed,
    required this.onPopButtonPressed,
    required this.onPopToSx10ButtonPressed,
    required this.onRemoveSx10ButtonPressed,
    required this.onRemoveSx20ButtonPressed,
    required this.onResetStackButtonPressed,
    required this.onToSetAButtonPressed,
    required this.toSetAButtonText,
    required this.onToSetBButtonPressed,
    required this.toSetBButtonText,
    super.key,
  });

  final RubigoControllerMixin controller;
  final Screens sX10Screen;
  final Screens sX20Screen;
  final Screens sX30Screen;
  final Screens sX40Screen;
  final ValueNotifier<bool> allowBackGesture;
  final ValueNotifier<bool> backButtonAllowed;
  final VoidCallback onPushSx040ButtonPressed;
  final VoidCallback onPopButtonPressed;
  final VoidCallback onPopToSx10ButtonPressed;
  final VoidCallback onRemoveSx10ButtonPressed;
  final VoidCallback onRemoveSx20ButtonPressed;
  final VoidCallback onResetStackButtonPressed;
  final VoidCallback onToSetAButtonPressed;
  final String toSetAButtonText;
  final VoidCallback onToSetBButtonPressed;
  final String toSetBButtonText;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: allowBackGesture,
      builder: (context, allowBackGesture, child) {
        return PopScope(
          canPop: allowBackGesture,
          child: child!,
        );
      },
      child: Scaffold(
        appBar: AppBar(
          leading: rubigoBackButton(context, controller.rubigoRouter),
          title: AppBarTitleBreadCrumbs(
            title: sX30Screen.name.toUpperCase(),
            screens: controller.rubigoRouter.screens,
          ),
        ),
        body: Center(
          child: Wrap(
            direction: Axis.vertical,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 4,
            children: [
              const Text('Allow back gesture'),
              ValueListenableBuilder(
                valueListenable: allowBackGesture,
                builder: (context, value, _) => Switch(
                  value: value,
                  onChanged: (value) => allowBackGesture.value = value,
                ),
              ),
              const Text('mayPop ui.pop'),
              ValueListenableBuilder(
                valueListenable: backButtonAllowed,
                builder: (context, value, _) => Switch(
                  value: value,
                  onChanged: (value) => backButtonAllowed.value = value,
                ),
              ),
              NavigateButton(
                screens: controller.rubigoRouter.screens,
                isEnabled: (_) => true,
                onPressed: onPushSx040ButtonPressed,
                child: Text('Push ${sX40Screen.name.toUpperCase()}'),
              ),
              NavigateButton(
                screens: controller.rubigoRouter.screens,
                isEnabled: (screenStack) => screenStack.hasScreenBelow(),
                onPressed: onPopButtonPressed,
                child: const Text('Pop'),
              ),
              NavigateButton(
                screens: controller.rubigoRouter.screens,
                isEnabled: (screenStack) =>
                    screenStack.containsScreenBelow(sX10Screen),
                onPressed: onPopToSx10ButtonPressed,
                child: Text('PopTo ${sX10Screen.name.toUpperCase()}'),
              ),
              NavigateButton(
                screens: controller.rubigoRouter.screens,
                isEnabled: (screenStack) =>
                    screenStack.containsScreenBelow(sX10Screen),
                onPressed: onRemoveSx10ButtonPressed,
                child: Text('Remove ${sX10Screen.name.toUpperCase()}'),
              ),
              NavigateButton(
                screens: controller.rubigoRouter.screens,
                isEnabled: (screenStack) =>
                    screenStack.containsScreenBelow(sX20Screen),
                onPressed: onRemoveSx20ButtonPressed,
                child: Text('Remove ${sX20Screen.name.toUpperCase()}'),
              ),
              ElevatedButton(
                onPressed: onResetStackButtonPressed,
                child: const Text('Reset stack'),
              ),
              ElevatedButton(
                onPressed: onToSetAButtonPressed,
                child: Text(toSetAButtonText),
              ),
              ElevatedButton(
                onPressed: onToSetBButtonPressed,
                child: Text(toSetBButtonText),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
