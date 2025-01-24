import 'package:example/screens/screens.dart';
import 'package:example/screens/set1/screen_stack_backup_set1.dart';
import 'package:example/screens/set2/screen_stack_backup_set2.dart';
import 'package:example/screens/set3/screen_stack_backup_set3.dart';
import 'package:flutter/cupertino.dart';
import 'package:rubigo_router/rubigo_router.dart';

class S120Controller with RubigoControllerMixin<Screens> {
  final backButtonAllowed = ValueNotifier(true);

  @override
  Future<bool> mayPop() async => backButtonAllowed.value;

  Future<void> onS130ButtonPressed() async {
    await rubigoRouter.push(Screens.s130, ignoreWhenBusy: true);
  }

  Future<void> onPopButtonPressed() async {
    await rubigoRouter.pop(ignoreWhenBusy: true);
  }

  Future<void> onPopToS100ButtonPressed() async {
    await rubigoRouter.popTo(Screens.s100, ignoreWhenBusy: true);
  }

  Future<void> onRemoveS110ButtonPressed() async {
    rubigoRouter.remove(Screens.s110, ignoreWhenBusy: true);
  }

  Future<void> onRemoveS100ButtonPressed() async {
    rubigoRouter.remove(Screens.s100, ignoreWhenBusy: true);
  }

  Future<void> resetStack() async {
    await rubigoRouter.replaceStack(
      [
        Screens.s100,
        Screens.s110,
        Screens.s120,
      ],
      ignoreWhenBusy: true,
    );
  }

  Future<void> toSet2() async {
    screenStackBackupSet1 = rubigoRouter.screens.value.toListOfScreenId();
    await rubigoRouter.replaceStack(
      screenStackBackupSet2,
      ignoreWhenBusy: true,
    );
  }

  Future<void> toSet3() async {
    screenStackBackupSet1 = rubigoRouter.screens.value.toListOfScreenId();
    await rubigoRouter.replaceStack(
      screenStackBackupSet3,
      ignoreWhenBusy: true,
    );
  }
}
