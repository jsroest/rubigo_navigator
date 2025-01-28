import 'package:example/screens/set1/s120/s120_controller.dart';
import 'package:example/screens/widgets/sx20_screen.dart';
import 'package:flutter/material.dart';
import 'package:rubigo_router/rubigo_router.dart';

class S120Screen extends StatelessWidget
    with RubigoScreenMixin<S120Controller> {
  S120Screen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Sx20Screen(
      controller: controller,
      title: 'S120',
      onPushButtonPressed: controller.onS130ButtonPressed,
      pushButtonText: 'Push 130',
      onPopButtonPressed: controller.onPopButtonPressed,
      popButtonText: 'Pop',
    );
  }
}
