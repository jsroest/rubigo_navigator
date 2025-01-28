import 'package:example/screens/set3/s310/s310_controller.dart';
import 'package:example/widgets/app_bar_title_breadcrumbs.dart';
import 'package:example/widgets/navigate_button.dart';
import 'package:flutter/material.dart';
import 'package:rubigo_router/rubigo_router.dart';

class S310Screen extends StatelessWidget
    with RubigoScreenMixin<S310Controller> {
  S310Screen({
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
            title: 'S310',
            screens: controller.rubigoRouter.screens,
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: controller.onS320ButtonPressed,
                child: const Text('Push S320'),
              ),
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
