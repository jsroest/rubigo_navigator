import 'package:example/screens/screens.dart';
import 'package:example/screens/set2/s230/s230_controller.dart';
import 'package:example/screens/widgets/sx30_screen.dart';
import 'package:flutter/material.dart';
import 'package:rubigo_router/rubigo_router.dart';

class S230Screen extends StatelessWidget
    with RubigoScreenMixin<S230Controller> {
  S230Screen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Sx30Screen(
      controller: controller,
      sX10Screen: Screens.s210,
      sX20Screen: Screens.s220,
      sX30Screen: Screens.s230,
      sX40Screen: Screens.s230,
      allowBackGesture: controller.allowBackGesture,
      backButtonAllowed: controller.backButtonAllowed,
      onPushSx040ButtonPressed: controller.onPushS240ButtonPressed,
      onPopButtonPressed: controller.onPopButtonPressed,
      onPopToSx10ButtonPressed: controller.onPopToS210ButtonPressed,
      onRemoveSx10ButtonPressed: controller.onRemoveS210ButtonPressed,
      onRemoveSx20ButtonPressed: controller.onRemoveS220ButtonPressed,
      onResetStackButtonPressed: controller.onResetStackButtonPressed,
      onToSetAButtonPressed: controller.onToSetAButtonPressed,
      toSetAButtonText: 'Replace set 1',
      onToSetBButtonPressed: controller.onToSetBButtonPressed,
      toSetBButtonText: 'Replace set 3',
    );
  }
}
