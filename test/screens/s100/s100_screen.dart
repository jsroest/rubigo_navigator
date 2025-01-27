import 'package:flutter/material.dart';
import 'package:rubigo_router/rubigo_router.dart';

class S100Screen extends StatelessWidget with RubigoScreenMixin {
  S100Screen({super.key});

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
