import 'package:flutter/material.dart';
import 'package:rubigo_router/rubigo_router.dart';

import 's100_controller.dart';

class S100Screen extends StatelessWidget
    with RubigoScreenMixin<S100RubigoController> {
  S100Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: rubigoBackButton(context, controller.rubigoRouter),
      ),
      body: ValueListenableBuilder(
        valueListenable: controller.allowBackGesture,
        builder: (context, value, child) {
          return RubigoBackGesture(
            allowBackGesture: value,
            rubigoRouter: controller.rubigoRouter,
            child: const Placeholder(),
          );
        },
      ),
    );
  }
}
