import 'package:example/screens/screens.dart';
import 'package:example/screens/set1/s120/s120_controller.dart';
import 'package:example/widgets/app_bar_title_breadcrumbs.dart';
import 'package:example/widgets/navigate_button.dart';
import 'package:flutter/material.dart';
import 'package:rubigo_router/rubigo_router.dart';

class S120Screen extends StatelessWidget
    with RubigoScreenMixin<S120Controller> {
  S120Screen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppBarTitleBreadCrumbs(
          title: 'S120',
          screens: controller.rubigoRouter.screens,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('mayPop on back button'),
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
              onPressed: controller.onS130ButtonPressed,
              child: const Text('Push S130'),
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
                  screenStack.containsScreenBelow(Screens.s100),
              onPressed: controller.onPopToS100ButtonPressed,
              child: const Text('PopTo S100'),
            ),
            NavigateButton(
              screens: controller.rubigoRouter.screens,
              isEnabled: (screenStack) =>
                  screenStack.containsScreenBelow(Screens.s110),
              onPressed: controller.onRemoveS110ButtonPressed,
              child: const Text('Remove S110'),
            ),
            NavigateButton(
              screens: controller.rubigoRouter.screens,
              isEnabled: (screenStack) =>
                  screenStack.containsScreenBelow(Screens.s100),
              onPressed: controller.onRemoveS100ButtonPressed,
              child: const Text('Remove S100'),
            ),
            ElevatedButton(
              onPressed: controller.resetStack,
              child: const Text('Reset stack'),
            ),
            ElevatedButton(
              onPressed: controller.toSet2,
              child: const Text('Replace stack with set 2'),
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
