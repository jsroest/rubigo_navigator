import 'package:example/screens/screens.dart';
import 'package:example/widgets/app_bar_title_breadcrumbs.dart';
import 'package:example/widgets/navigate_button.dart';
import 'package:flutter/material.dart';
import 'package:rubigo_router/rubigo_router.dart';

class Sx20Screen extends StatelessWidget {
  const Sx20Screen({
    required this.controller,
    required this.sX20Screen,
    required this.sX30Screen,
    required this.onPushButtonPressed,
    required this.onPopButtonPressed,
    super.key,
  });

  final RubigoControllerMixin controller;
  final Screens sX20Screen;
  final Screens sX30Screen;
  final VoidCallback onPushButtonPressed;
  final VoidCallback onPopButtonPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: rubigoBackButton(context, controller.rubigoRouter),
        title: AppBarTitleBreadCrumbs(
          title: sX20Screen.name.toUpperCase(),
          screens: controller.rubigoRouter.screens,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: onPushButtonPressed,
              child: Text('Push ${sX30Screen.name.toUpperCase()}'),
            ),
            NavigateButton(
              screens: controller.rubigoRouter.screens,
              isEnabled: (screenStack) => screenStack.hasScreenBelow(),
              onPressed: onPopButtonPressed,
              child: const Text('Pop'),
            ),
          ],
        ),
      ),
    );
  }
}
