import 'package:example/widgets/app_bar_title_breadcrumbs.dart';
import 'package:flutter/material.dart';
import 'package:rubigo_router/rubigo_router.dart';

class Sx10Screen extends StatelessWidget {
  const Sx10Screen({
    required this.controller,
    required this.title,
    required this.onButtonPressed,
    required this.buttonText,
    super.key,
  });

  final RubigoControllerMixin controller;
  final String title;
  final VoidCallback onButtonPressed;
  final String buttonText;

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
              onPressed: onButtonPressed,
              child: Text(buttonText),
            ),
          ],
        ),
      ),
    );
  }
}
