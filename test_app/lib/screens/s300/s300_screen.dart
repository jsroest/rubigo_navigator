import 'package:demo_rubigo_navigator/screens/s300/s300_controller.dart';
import 'package:flutter/material.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';

/// Shows a list of posts

/// Shows the details of a post

class S300Screen extends StatelessWidget
    with RubigoControllerMixin<S300Controller> {
  /// The post to display in this screen

  S300Screen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: controller.canPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('S300'),
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
                onPressed: controller.onPopButtonPressed,
                child: const Text('Pop'),
              ),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(
                onPressed: controller.onPopToS100ButtonPressed,
                child: const Text('PopTo S100'),
              ),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(
                onPressed: controller.onRemoveS200ButtonPressed,
                child: const Text('Remove S200'),
              ),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(
                onPressed: controller.onRemoveS100ButtonPressed,
                child: const Text('Remove S100'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
