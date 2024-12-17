import 'package:demo_rubigo_navigator/screens/s200/s200_controller.dart';
import 'package:flutter/material.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';

class S200Screen extends StatelessWidget
    with RubigoControllerMixin<S200Controller> {
  S200Screen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: controller.canPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('S200'),
          automaticallyImplyLeading: false,
          leading: controller.canPop ? const BackButton() : null,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(
                onPressed: controller.onS300ButtonPressed,
                child: const Text('Push S300'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: controller.onBackButtonPressed,
                child: const Text('Pop'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
