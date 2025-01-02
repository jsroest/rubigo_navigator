import 'package:example/screens/screens.dart';
import 'package:example/screens/set1/screen_stack_backup_set1.dart';
import 'package:example/screens/set2/screen_stack_backup_set2.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';

class S700Controller with RubigoController<Screens> {
  Future<void> onPopButtonPressed() async {
    await rubigoRouter.pop();
  }

  Future<void> onPopToS500ButtonPressed() async {
    await rubigoRouter.whenNotBusy?.popTo(Screens.s500);
  }

  Future<void> onRemoveS600ButtonPressed() async {
    rubigoRouter.whenNotBusy?.remove(Screens.s600);
  }

  Future<void> onRemoveS500ButtonPressed() async {
    rubigoRouter.whenNotBusy?.remove(Screens.s500);
  }

  Future<void> resetStack() async {
    await rubigoRouter.whenNotBusy?.replaceStack([
      Screens.s500,
      Screens.s600,
      Screens.s700,
    ]);
  }

  Future<void> toSet1() async {
    screenStackBackupSet2 = rubigoRouter.screenStackNotifier.value;
    await rubigoRouter.replaceStack(screenStackBackupSet1);
  }
}
