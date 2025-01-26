import 'package:example/screens/screens.dart';
import 'package:example/screens/set1/screen_stack_backup_set1.dart';
import 'package:example/screens/set2/screen_stack_backup_set2.dart';
import 'package:example/screens/set3/screen_stack_backup_set3.dart';
import 'package:flutter/widgets.dart';
import 'package:rubigo_router/rubigo_router.dart';

class S320Controller with RubigoControllerMixin<Screens> {
  final backButtonAllowed = ValueNotifier(true);

  @override
  Future<bool> mayPop() async => backButtonAllowed.value;

  Future<void> onS330ButtonPressed() async {
    await rubigoRouter.ui.push(Screens.s330);
  }

  Future<void> onPopButtonPressed() async {
    await rubigoRouter.ui.pop();
  }

  Future<void> onPopToS300ButtonPressed() async {
    await rubigoRouter.ui.popTo(Screens.s300);
  }

  Future<void> onRemoveS310ButtonPressed() async {
    await rubigoRouter.ui.remove(Screens.s310);
  }

  Future<void> onRemoveS300ButtonPressed() async {
    await rubigoRouter.ui.remove(Screens.s300);
  }

  Future<void> resetStack() async {
    await rubigoRouter.ui.replaceStack(
      [
        Screens.s300,
        Screens.s310,
        Screens.s320,
      ],
    );
  }

  Future<void> toSet1() async {
    screenStackBackupSet3 = rubigoRouter.screens.value.toListOfScreenId();
    await rubigoRouter.ui.replaceStack(screenStackBackupSet1);
  }

  Future<void> toSet2() async {
    screenStackBackupSet3 = rubigoRouter.screens.value.toListOfScreenId();
    await rubigoRouter.ui.replaceStack(screenStackBackupSet2);
  }
}
