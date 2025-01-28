import 'package:example/screens/screens.dart';
import 'package:example/screens/set3/s330/s330_controller.dart';
import 'package:example/widgets/app_bar_title_breadcrumbs.dart';
import 'package:example/widgets/navigate_button.dart';
import 'package:flutter/material.dart';
import 'package:rubigo_router/rubigo_router.dart';

class S330Screen extends StatelessWidget
    with RubigoScreenMixin<S330Controller> {
  S330Screen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          leading: rubigoBackButton(context, controller.rubigoRouter),
          title: AppBarTitleBreadCrumbs(
            title: 'S330',
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
                onPressed: controller.onS340ButtonPressed,
                child: const Text('Push S340'),
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
                    screenStack.containsScreenBelow(Screens.s310),
                onPressed: controller.onPopToS310ButtonPressed,
                child: const Text('PopTo S310'),
              ),
              NavigateButton(
                screens: controller.rubigoRouter.screens,
                isEnabled: (screenStack) =>
                    screenStack.containsScreenBelow(Screens.s320),
                onPressed: controller.onRemoveS320ButtonPressed,
                child: const Text('Remove S320'),
              ),
              NavigateButton(
                screens: controller.rubigoRouter.screens,
                isEnabled: (screenStack) =>
                    screenStack.containsScreenBelow(Screens.s310),
                onPressed: controller.onRemoveS310ButtonPressed,
                child: const Text('Remove S310'),
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
                onPressed: controller.toSet2,
                child: const Text('Replace set 2'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
