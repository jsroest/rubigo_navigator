import 'package:example/screens/screens.dart';
import 'package:example/screens/set2/s700/s700_controller.dart';
import 'package:example/widgets/app_bar_title.dart';
import 'package:example/widgets/navigate_button.dart';
import 'package:flutter/material.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';

class S700Screen extends StatelessWidget
    with RubigoScreenMixin<S700Controller> {
  S700Screen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: controller.canPop,
      child: Scaffold(
        appBar: AppBar(
          title: AppBarTitle(
            title: 'S700',
            screenStackListener: controller.rubigoRouter.screenStackNotifier,
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 16,
              ),
              NavigateButton(
                screenStackListener:
                    controller.rubigoRouter.screenStackNotifier,
                isEnabled: (screenStack) => screenStack.hasScreenBelow(),
                onPressed: controller.onPopButtonPressed,
                child: const Text('Pop'),
              ),
              const SizedBox(
                height: 16,
              ),
              NavigateButton(
                screenStackListener:
                    controller.rubigoRouter.screenStackNotifier,
                isEnabled: (screenStack) =>
                    screenStack.containsScreenBelow(Screens.s500),
                onPressed: controller.onPopToS500ButtonPressed,
                child: const Text('PopTo S500'),
              ),
              const SizedBox(
                height: 16,
              ),
              NavigateButton(
                screenStackListener:
                    controller.rubigoRouter.screenStackNotifier,
                isEnabled: (screenStack) =>
                    screenStack.containsScreenBelow(Screens.s600),
                onPressed: controller.onRemoveS600ButtonPressed,
                child: const Text('Remove S600'),
              ),
              const SizedBox(
                height: 16,
              ),
              NavigateButton(
                screenStackListener:
                    controller.rubigoRouter.screenStackNotifier,
                isEnabled: (screenStack) =>
                    screenStack.containsScreenBelow(Screens.s500),
                onPressed: controller.onRemoveS500ButtonPressed,
                child: const Text('Remove S500'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: controller.resetStack,
                child: const Text('Reset stack'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: controller.toSet1,
                child: const Text('Replace stack with set 1'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
