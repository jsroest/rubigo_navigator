import 'package:example/screens/set2/s600/s600_controller.dart';
import 'package:example/widgets/app_bar_title.dart';
import 'package:example/widgets/navigate_button.dart';
import 'package:flutter/material.dart';
import 'package:rubigo_router/rubigo_router.dart';

class S600Screen extends StatelessWidget
    with RubigoScreenMixin<S600Controller> {
  S600Screen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RubigoControllerPopScope(
      controller: controller,
      child: Scaffold(
        appBar: AppBar(
          title: AppBarTitle(
            title: 'S600',
            screens: controller.rubigoRouter.screens,
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(
                onPressed: controller.onS700ButtonPressed,
                child: const Text('Push S700'),
              ),
              const SizedBox(height: 16),
              NavigateButton(
                screens: controller.rubigoRouter.screens,
                isEnabled: (screenStack) => screenStack.hasScreenBelow(),
                onPressed: controller.onPopButtonPressed,
                child: const Text('Pop'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
