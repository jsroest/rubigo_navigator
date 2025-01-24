import 'package:example/screens/screens.dart';
import 'package:example/screens/set2/s220/s220_controller.dart';
import 'package:example/widgets/app_bar_title_breadcrumbs.dart';
import 'package:example/widgets/navigate_button.dart';
import 'package:flutter/material.dart';
import 'package:rubigo_router/rubigo_router.dart';

class S220Screen extends StatelessWidget
    with RubigoScreenMixin<S220Controller> {
  S220Screen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppBarTitleBreadCrumbs(
          title: 'S220',
          screens: controller.rubigoRouter.screens,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NavigateButton(
              screens: controller.rubigoRouter.screens,
              isEnabled: (_) => true,
              onPressed: controller.onS230ButtonPressed,
              child: const Text('Push S230'),
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
                  screenStack.containsScreenBelow(Screens.s200),
              onPressed: controller.onPopToS200ButtonPressed,
              child: const Text('PopTo S200'),
            ),
            NavigateButton(
              screens: controller.rubigoRouter.screens,
              isEnabled: (screenStack) =>
                  screenStack.containsScreenBelow(Screens.s210),
              onPressed: controller.onRemoveS210ButtonPressed,
              child: const Text('Remove S210'),
            ),
            NavigateButton(
              screens: controller.rubigoRouter.screens,
              isEnabled: (screenStack) =>
                  screenStack.containsScreenBelow(Screens.s200),
              onPressed: controller.onRemoveS200ButtonPressed,
              child: const Text('Remove S200'),
            ),
            ElevatedButton(
              onPressed: controller.resetStack,
              child: const Text('Reset stack'),
            ),
            ElevatedButton(
              onPressed: controller.toSet1,
              child: const Text('Replace stack with set 1'),
            ),
            ElevatedButton(
              onPressed: controller.toSet3,
              child: const Text('Replace stack with set 3'),
            ),
          ],
        ),
      ),
    );
  }
}
