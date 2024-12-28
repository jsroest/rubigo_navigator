import 'package:example/screens/set2/s500/s500_controller.dart';
import 'package:flutter/material.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';

class S500Screen extends StatelessWidget
    with RubigoScreenMixin<S500Controller> {
  S500Screen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: controller.canPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('S500'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: double.infinity, height: 16),
            ElevatedButton(
              onPressed: controller.onS600ButtonPressed,
              child: const Text('Push S600'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: controller.replaceStack,
              child: const Text('Replace stack'),
            ),
          ],
        ),
      ),
    );
  }
}
