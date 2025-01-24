import 'package:example/screens/set2/s210/s210_controller.dart';
import 'package:example/widgets/app_bar_title.dart';
import 'package:example/widgets/navigate_button.dart';
import 'package:flutter/material.dart';
import 'package:rubigo_router/rubigo_router.dart';

class S210Screen extends StatelessWidget
    with RubigoScreenMixin<S210Controller> {
  S210Screen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle(
          title: 'S210',
          screens: controller.rubigoRouter.screens,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: controller.onS220ButtonPressed,
              child: const Text('Push S220'),
            ),
            const SizedBox(height: 8),
            NavigateButton(
              screens: controller.rubigoRouter.screens,
              isEnabled: (screenStack) => screenStack.hasScreenBelow(),
              onPressed: controller.onPopButtonPressed,
              child: const Text('Pop'),
            ),
          ],
        ),
      ),
    );
  }
}
