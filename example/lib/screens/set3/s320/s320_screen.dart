import 'package:example/screens/screens.dart';
import 'package:example/screens/set3/s320/s320_controller.dart';
import 'package:example/widgets/app_bar_title_breadcrumbs.dart';
import 'package:example/widgets/navigate_button.dart';
import 'package:flutter/material.dart';
import 'package:rubigo_router/rubigo_router.dart';

class S320Screen extends StatelessWidget
    with RubigoScreenMixin<S320Controller> {
  S320Screen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RubigoPopScope(
      rubigoRouter: controller.rubigoRouter,
      child: Scaffold(
        appBar: AppBar(
          title: AppBarTitleBreadCrumbs(
            title: 'S320',
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
                onPressed: controller.onS330ButtonPressed,
                child: const Text('Push S330'),
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
                    screenStack.containsScreenBelow(Screens.s300),
                onPressed: controller.onPopToS300ButtonPressed,
                child: const Text('PopTo S300'),
              ),
              NavigateButton(
                screens: controller.rubigoRouter.screens,
                isEnabled: (screenStack) =>
                    screenStack.containsScreenBelow(Screens.s310),
                onPressed: controller.onRemoveS310ButtonPressed,
                child: const Text('Remove S310'),
              ),
              NavigateButton(
                screens: controller.rubigoRouter.screens,
                isEnabled: (screenStack) =>
                    screenStack.containsScreenBelow(Screens.s300),
                onPressed: controller.onRemoveS300ButtonPressed,
                child: const Text('Remove S300'),
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
                onPressed: controller.toSet2,
                child: const Text('Replace stack with set 2'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
