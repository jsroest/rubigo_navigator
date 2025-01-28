import 'package:example/screens/screens.dart';
import 'package:example/screens/set1/screen_stack_backup_set1.dart';
import 'package:example/screens/set2/screen_stack_backup_set2.dart';
import 'package:example/screens/set3/screen_stack_backup_set3.dart';
import 'package:flutter/foundation.dart';
import 'package:rubigo_router/rubigo_router.dart';

class S230Controller with RubigoControllerMixin<Screens> {
  final backButtonAllowed = ValueNotifier(true);

  @override
  Future<bool> mayPop() async => backButtonAllowed.value;

  Future<void> onS240ButtonPressed() async {
    await rubigoRouter.ui.push(Screens.s240);
  }

  Future<void> onPopButtonPressed() async {
    await rubigoRouter.ui.pop();
  }

  Future<void> onPopToS210ButtonPressed() async {
    await rubigoRouter.ui.popTo(Screens.s210);
  }

  Future<void> onRemoveS220ButtonPressed() async {
    await rubigoRouter.ui.remove(Screens.s220);
  }

  Future<void> onRemoveS210ButtonPressed() async {
    await rubigoRouter.ui.remove(Screens.s210);
  }

  Future<void> resetStack() async {
    await rubigoRouter.ui.replaceStack(
      [
        Screens.s210,
        Screens.s220,
        Screens.s230,
      ],
    );
  }

  Future<void> toSet1() async {
    screenStackBackupSet2 = rubigoRouter.screens.value.toListOfScreenId();
    await rubigoRouter.ui.replaceStack(screenStackBackupSet1);
  }

  Future<void> toSet3() async {
    screenStackBackupSet2 = rubigoRouter.screens.value.toListOfScreenId();
    await rubigoRouter.ui.replaceStack(screenStackBackupSet3);
  }
}
