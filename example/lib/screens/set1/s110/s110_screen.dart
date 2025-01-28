import 'package:example/screens/set1/s110/s110_controller.dart';
import 'package:example/widgets/app_bar_title_breadcrumbs.dart';
import 'package:flutter/material.dart';
import 'package:rubigo_router/rubigo_router.dart';

class S110Screen extends StatelessWidget
    with RubigoScreenMixin<S110Controller> {
  S110Screen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: rubigoBackButton(context, controller.rubigoRouter),
        title: AppBarTitleBreadCrumbs(
          title: 'S110',
          screens: controller.rubigoRouter.screens,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: controller.onS120ButtonPressed,
              child: const Text('Push S120'),
            ),
          ],
        ),
      ),
    );
  }
}
