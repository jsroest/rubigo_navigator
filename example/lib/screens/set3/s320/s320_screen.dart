import 'package:example/screens/set3/s320/s320_controller.dart';
import 'package:example/screens/widgets/sx20_screen.dart';
import 'package:flutter/material.dart';
import 'package:rubigo_router/rubigo_router.dart';

class S320Screen extends StatelessWidget
    with RubigoScreenMixin<S320Controller> {
  S320Screen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Sx20Screen(
      controller: controller,
      title: 'S320',
      onPushButtonPressed: controller.onS330ButtonPressed,
      pushButtonText: 'Push 330',
      onPopButtonPressed: controller.onPopButtonPressed,
      popButtonText: 'Pop',
    );
  }
}
