import 'package:example/screens/screens.dart';
import 'package:example/screens/set2/s230/s230_controller.dart';
import 'package:example/widgets/app_bar_title_breadcrumbs.dart';
import 'package:example/widgets/navigate_button.dart';
import 'package:flutter/material.dart';
import 'package:rubigo_router/rubigo_router.dart';

class S230Screen extends StatelessWidget
    with RubigoScreenMixin<S230Controller> {
  S230Screen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: rubigoBackButton(context, controller.rubigoRouter),
        title: AppBarTitleBreadCrumbs(
          title: 'S230',
          screens: controller.rubigoRouter.screens,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('mayPop on ui.pop'),
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
              onPressed: controller.onS240ButtonPressed,
              child: const Text('Push S240'),
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
                  screenStack.containsScreenBelow(Screens.s210),
              onPressed: controller.onPopToS210ButtonPressed,
              child: const Text('PopTo S210'),
            ),
            NavigateButton(
              screens: controller.rubigoRouter.screens,
              isEnabled: (screenStack) =>
                  screenStack.containsScreenBelow(Screens.s220),
              onPressed: controller.onRemoveS220ButtonPressed,
              child: const Text('Remove S220'),
            ),
            NavigateButton(
              screens: controller.rubigoRouter.screens,
              isEnabled: (screenStack) =>
                  screenStack.containsScreenBelow(Screens.s210),
              onPressed: controller.onRemoveS210ButtonPressed,
              child: const Text('Remove S210'),
            ),
            ElevatedButton(
              onPressed: controller.resetStack,
              child: const Text('Reset stack'),
            ),
            ElevatedButton(
              onPressed: controller.toSet1,
              child: const Text('Replace set 1'),
            ),
            ElevatedButton(
              onPressed: controller.toSet3,
              child: const Text('Replace set 3'),
            ),
          ],
        ),
      ),
    );
  }
}
