import 'package:example/screens/screens.dart';
import 'package:example/screens/set1/screen_stack_backup_set1.dart';
import 'package:example/screens/set2/screen_stack_backup_set2.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';

class S700Controller with RubigoController<Screens> {
  Future<void> onPopButtonPressed() async {
    await rubigoRouter.pop(ignoreWhenBusy: true);
  }

  Future<void> onPopToS500ButtonPressed() async {
    await rubigoRouter.popTo(Screens.s500, ignoreWhenBusy: true);
  }

  Future<void> onRemoveS600ButtonPressed() async {
    rubigoRouter.remove(Screens.s600, ignoreWhenBusy: true);
  }

  Future<void> onRemoveS500ButtonPressed() async {
    rubigoRouter.remove(Screens.s500, ignoreWhenBusy: true);
  }

  Future<void> resetStack() async {
    await rubigoRouter.replaceStack(
      [
        Screens.s500,
        Screens.s600,
        Screens.s700,
      ],
      ignoreWhenBusy: true,
    );
  }

  Future<void> toSet1() async {
    screenStackBackupSet2 = rubigoRouter.screenStackNotifier.value;
    await rubigoRouter.replaceStack(screenStackBackupSet1,
        ignoreWhenBusy: true);
  }
}
