import 'package:example/widgets/app_bar_title_breadcrumbs.dart';
import 'package:example/widgets/navigate_button.dart';
import 'package:flutter/material.dart';
import 'package:rubigo_router/rubigo_router.dart';

class Sx20Screen extends StatelessWidget {
  const Sx20Screen({
    required this.controller,
    required this.title,
    required this.onPushButtonPressed,
    required this.pushButtonText,
    required this.onPopButtonPressed,
    required this.popButtonText,
    super.key,
  });

  final RubigoControllerMixin controller;
  final String title;
  final VoidCallback onPushButtonPressed;
  final String pushButtonText;
  final VoidCallback onPopButtonPressed;
  final String popButtonText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: rubigoBackButton(context, controller.rubigoRouter),
        title: AppBarTitleBreadCrumbs(
          title: title,
          screens: controller.rubigoRouter.screens,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: onPushButtonPressed,
              child: Text(pushButtonText),
            ),
            NavigateButton(
              screens: controller.rubigoRouter.screens,
              isEnabled: (screenStack) => screenStack.hasScreenBelow(),
              onPressed: onPopButtonPressed,
              child: Text(popButtonText),
            ),
          ],
        ),
      ),
    );
  }
}
