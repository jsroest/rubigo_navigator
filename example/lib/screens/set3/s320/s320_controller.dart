import 'package:example/screens/screens.dart';
import 'package:example/screens/set1/screen_stack_backup_set1.dart';
import 'package:example/screens/set2/screen_stack_backup_set2.dart';
import 'package:example/screens/set3/screen_stack_backup_set3.dart';
import 'package:rubigo_router/rubigo_router.dart';

class S320Controller with RubigoControllerMixin<Screens> {
  Future<void> onS330ButtonPressed() async {
    await rubigoRouter.push(Screens.s330, ignoreWhenBusy: true);
  }

  Future<void> onPopButtonPressed() async {
    await rubigoRouter.pop(ignoreWhenBusy: true);
  }

  Future<void> onPopToS300ButtonPressed() async {
    await rubigoRouter.popTo(Screens.s300, ignoreWhenBusy: true);
  }

  Future<void> onRemoveS310ButtonPressed() async {
    rubigoRouter.remove(Screens.s310, ignoreWhenBusy: true);
  }

  Future<void> onRemoveS300ButtonPressed() async {
    rubigoRouter.remove(Screens.s300, ignoreWhenBusy: true);
  }

  Future<void> resetStack() async {
    await rubigoRouter.replaceStack(
      [
        Screens.s300,
        Screens.s310,
        Screens.s320,
      ],
      ignoreWhenBusy: true,
    );
  }

  Future<void> toSet1() async {
    screenStackBackupSet3 = rubigoRouter.screens.value.toListOfScreenId();
    await rubigoRouter.replaceStack(
      screenStackBackupSet1,
      ignoreWhenBusy: true,
    );
  }

  Future<void> toSet2() async {
    screenStackBackupSet3 = rubigoRouter.screens.value.toListOfScreenId();
    await rubigoRouter.replaceStack(
      screenStackBackupSet2,
      ignoreWhenBusy: true,
    );
  }
}
