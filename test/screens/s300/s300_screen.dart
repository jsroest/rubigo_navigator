import 'package:flutter/material.dart';
import 'package:rubigo_router/rubigo_router.dart';

import 's300_controller.dart';

class S300Screen extends StatelessWidget
    with RubigoScreenMixin<S300RubigoController> {
  S300Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: rubigoBackButton(context, controller.rubigoRouter),
      ),
      body: const Placeholder(),
    );
  }
}
