import 'package:demo_rubigo_navigator/screens/s100/s100_controller.dart';
import 'package:flutter/material.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';

class S100Screen extends StatelessWidget
    with RubigoControllerMixin<S100Controller> {
  S100Screen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: controller.canPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('S100'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: double.infinity, height: 16),
            ElevatedButton(
              onPressed: controller.onS200ButtonPressed,
              child: const Text('S200'),
            ),
            const SizedBox(width: double.infinity, height: 16),
            ElevatedButton(
              onPressed: controller.onS300ButtonPressed,
              child: const Text('S300'),
            ),
          ],
        ),
      ),
    );
  }
}
