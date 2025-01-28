import 'package:example/screens/screens.dart';
import 'package:example/screens/set1/screen_stack_backup_set1.dart';
import 'package:example/screens/set2/screen_stack_backup_set2.dart';
import 'package:example/screens/set3/screen_stack_backup_set3.dart';
import 'package:flutter/cupertino.dart';
import 'package:rubigo_router/rubigo_router.dart';

class S130Controller with RubigoControllerMixin<Screens> {
  final allowBackGesture = ValueNotifier(false);

  final backButtonAllowed = ValueNotifier(true);

  @override
  Future<bool> mayPop() async => backButtonAllowed.value;

  Future<void> onS140ButtonPressed() async {
    await rubigoRouter.ui.push(Screens.s140);
  }

  Future<void> onPopButtonPressed() async {
    await rubigoRouter.ui.pop();
  }

  Future<void> onPopToS110ButtonPressed() async {
    await rubigoRouter.ui.popTo(Screens.s110);
  }

  Future<void> onRemoveS120ButtonPressed() async {
    await rubigoRouter.ui.remove(Screens.s120);
  }

  Future<void> onRemoveS110ButtonPressed() async {
    await rubigoRouter.ui.remove(Screens.s110);
  }

  Future<void> resetStack() async {
    await rubigoRouter.ui.replaceStack(
      [
        Screens.s110,
        Screens.s120,
        Screens.s130,
      ],
    );
  }

  Future<void> toSet2() async {
    screenStackBackupSet1 = rubigoRouter.screens.value.toListOfScreenId();
    await rubigoRouter.ui.replaceStack(screenStackBackupSet2);
  }

  Future<void> toSet3() async {
    screenStackBackupSet1 = rubigoRouter.screens.value.toListOfScreenId();
    await rubigoRouter.ui.replaceStack(screenStackBackupSet3);
  }
}
