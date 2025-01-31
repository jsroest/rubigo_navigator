import 'package:flutter/material.dart';
import 'package:rubigo_router/rubigo_router.dart';

import 's400_controller.dart';

class S400Screen extends StatelessWidget
    with RubigoScreenMixin<S400RubigoController> {
  S400Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          //leading: rubigoBackButton(context, controller.rubigoRouter),
          //Test workaround
          ),
      body: const Placeholder(),
    );
  }
}
