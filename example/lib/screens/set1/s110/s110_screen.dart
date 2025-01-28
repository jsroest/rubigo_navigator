import 'package:example/screens/set1/s110/s110_controller.dart';
import 'package:example/screens/widgets/sx10_screen.dart';
import 'package:flutter/material.dart';
import 'package:rubigo_router/rubigo_router.dart';

class S110Screen extends StatelessWidget
    with RubigoScreenMixin<S110Controller> {
  S110Screen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Sx10Screen(
      controller: controller,
      title: 'S110',
      onButtonPressed: controller.onS120ButtonPressed,
      buttonText: 'Push 120',
    );
  }
}
