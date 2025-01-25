import 'package:example/screens/set3/s300/s300_controller.dart';
import 'package:example/widgets/app_bar_title_breadcrumbs.dart';
import 'package:flutter/material.dart';
import 'package:rubigo_router/rubigo_router.dart';

class S300Screen extends StatelessWidget
    with RubigoScreenMixin<S300Controller> {
  S300Screen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RubigoPopScope(
      rubigoRouter: controller.rubigoRouter,
      child: Scaffold(
        appBar: AppBar(
          leading: rubigoBackButton(context, controller.rubigoRouter),
          title: AppBarTitleBreadCrumbs(
            title: 'S300',
            screens: controller.rubigoRouter.screens,
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: controller.onS310ButtonPressed,
                child: const Text('Push S310'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
