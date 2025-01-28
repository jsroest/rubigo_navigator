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
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          leading: rubigoBackButton(context, controller.rubigoRouter),
          title: AppBarTitleBreadCrumbs(
            title: 'S320',
            screens: controller.rubigoRouter.screens,
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: controller.onS330ButtonPressed,
                child: const Text('Push S330'),
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
