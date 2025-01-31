import 'package:flutter/material.dart';
import 'package:rubigo_router/rubigo_router.dart';

import 's500_controller.dart';

class S500Screen extends StatelessWidget
    with RubigoScreenMixin<S500RubigoController> {
  S500Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return RubigoBackGesture(
      allowBackGesture: false,
      rubigoRouter: controller.rubigoRouter,
      child: Scaffold(
        appBar: AppBar(
            //leading: rubigoBackButton(context, controller.rubigoRouter),
            //Test workaround
            ),
        body: const Placeholder(),
      ),
    );
  }
}
