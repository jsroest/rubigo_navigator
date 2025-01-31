import 'package:flutter/material.dart';
import 'package:rubigo_router/rubigo_router.dart';

import 's200_controller.dart';

class S200Screen extends StatelessWidget
    with RubigoScreenMixin<S200RubigoController> {
  S200Screen({super.key});

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
