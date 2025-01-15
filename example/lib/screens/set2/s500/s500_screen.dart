import 'package:example/screens/set2/s500/s500_controller.dart';
import 'package:example/widgets/app_bar_title.dart';
import 'package:flutter/material.dart';
import 'package:rubigo_router/rubigo_router.dart';

class S500Screen extends StatelessWidget
    with RubigoScreenMixin<S500Controller> {
  S500Screen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RubigoControllerPopScope(
      controller: controller,
      child: Scaffold(
        appBar: AppBar(
          title: AppBarTitle(
            title: 'S500',
            screens: controller.rubigoRouter.screens,
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: double.infinity, height: 16),
            ElevatedButton(
              onPressed: controller.onS600ButtonPressed,
              child: const Text('Push S600'),
            ),
          ],
        ),
      ),
    );
  }
}
