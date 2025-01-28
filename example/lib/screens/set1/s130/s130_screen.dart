import 'package:example/screens/screens.dart';
import 'package:example/screens/set1/s130/s130_controller.dart';
import 'package:example/widgets/app_bar_title_breadcrumbs.dart';
import 'package:example/widgets/navigate_button.dart';
import 'package:flutter/material.dart';
import 'package:rubigo_router/rubigo_router.dart';

class S130Screen extends StatelessWidget
    with RubigoScreenMixin<S130Controller> {
  S130Screen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold(
      appBar: AppBar(
        leading: rubigoBackButton(context, controller.rubigoRouter),
        title: AppBarTitleBreadCrumbs(
          title: 'S130',
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
              valueListenable: controller.allowBackGesture,
              builder: (context, value, _) => Switch(
                value: value,
                onChanged: (value) => controller.allowBackGesture.value = value,
              ),
            ),
            const Text('mayPop ui.pop'),
            ValueListenableBuilder(
              valueListenable: controller.backButtonAllowed,
              builder: (context, value, _) => Switch(
                value: value,
                onChanged: (value) =>
                    controller.backButtonAllowed.value = value,
              ),
            ),
            NavigateButton(
              screens: controller.rubigoRouter.screens,
              isEnabled: (_) => true,
              onPressed: controller.onS140ButtonPressed,
              child: const Text('Push S140'),
            ),
            NavigateButton(
              screens: controller.rubigoRouter.screens,
              isEnabled: (screenStack) => screenStack.hasScreenBelow(),
              onPressed: controller.onPopButtonPressed,
              child: const Text('Pop'),
            ),
            NavigateButton(
              screens: controller.rubigoRouter.screens,
              isEnabled: (screenStack) =>
                  screenStack.containsScreenBelow(Screens.s110),
              onPressed: controller.onPopToS110ButtonPressed,
              child: const Text('PopTo S110'),
            ),
            NavigateButton(
              screens: controller.rubigoRouter.screens,
              isEnabled: (screenStack) =>
                  screenStack.containsScreenBelow(Screens.s120),
              onPressed: controller.onRemoveS120ButtonPressed,
              child: const Text('Remove S120'),
            ),
            NavigateButton(
              screens: controller.rubigoRouter.screens,
              isEnabled: (screenStack) =>
                  screenStack.containsScreenBelow(Screens.s110),
              onPressed: controller.onRemoveS110ButtonPressed,
              child: const Text('Remove S110'),
            ),
            ElevatedButton(
              onPressed: controller.resetStack,
              child: const Text('Reset stack'),
            ),
            ElevatedButton(
              onPressed: controller.toSet2,
              child: const Text('Replace set 2'),
            ),
            ElevatedButton(
              onPressed: controller.toSet3,
              child: const Text('Replace set 3'),
            ),
          ],
        ),
      ),
    );
    return ValueListenableBuilder(
      valueListenable: controller.allowBackGesture,
      child: scaffold,
      builder: (context, allowBackGesture, child) {
        if (allowBackGesture) {
          return child!;
        } else {
          return PopScope(
            canPop: false,
            child: child!,
          );
        }
      },
    );
  }
}
