import 'package:flutter/material.dart';
import 'package:rubigo_router/rubigo_router.dart';

class S300Screen extends StatelessWidget with RubigoScreenMixin {
  S300Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return RubigoPopScope(
      rubigoRouter: controller.rubigoRouter,
      child: Scaffold(
        appBar: AppBar(),
        body: const Placeholder(),
      ),
    );
  }
}
