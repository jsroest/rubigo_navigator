import 'package:example/screens/set1/s200/s200_controller.dart';
import 'package:example/widgets/app_bar_title.dart';
import 'package:example/widgets/navigate_button.dart';
import 'package:flutter/material.dart';
import 'package:rubigo_router/rubigo_router.dart';

class S200Screen extends StatelessWidget
    with RubigoScreenMixin<S200Controller> {
  S200Screen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RubigoControllerPopScope(
      controller: controller,
      child: Scaffold(
        appBar: AppBar(
          title: AppBarTitle(
            title: 'S200',
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
                onPressed: controller.onS300ButtonPressed,
                child: const Text('Push S300'),
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
