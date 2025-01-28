import 'package:example/screens/set3/s310/s310_controller.dart';
import 'package:example/screens/widgets/sx10_screen.dart';
import 'package:flutter/material.dart';
import 'package:rubigo_router/rubigo_router.dart';

class S310Screen extends StatelessWidget
    with RubigoScreenMixin<S310Controller> {
  S310Screen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Sx10Screen(
      controller: controller,
      title: 'S310',
      onButtonPressed: controller.onS320ButtonPressed,
      buttonText: 'Push 320',
    );
  }
}
