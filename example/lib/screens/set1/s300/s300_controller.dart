import 'package:example/screens/screens.dart';
import 'package:example/screens/set1/screen_stack_backup_set1.dart';
import 'package:example/screens/set2/screen_stack_backup_set2.dart';
import 'package:rubigo_router/rubigo_router.dart';

class S300Controller with RubigoControllerMixin<Screens> {
  Future<void> onPopButtonPressed() async {
    await rubigoRouter.pop(ignoreWhenBusy: true);
  }

  Future<void> onPopToS100ButtonPressed() async {
    await rubigoRouter.popTo(Screens.s100, ignoreWhenBusy: true);
  }

  Future<void> onRemoveS200ButtonPressed() async {
    rubigoRouter.remove(Screens.s200, ignoreWhenBusy: true);
  }

  Future<void> onRemoveS100ButtonPressed() async {
    rubigoRouter.remove(Screens.s100, ignoreWhenBusy: true);
  }

  Future<void> resetStack() async {
    await rubigoRouter.replaceStack(
      [
        Screens.s100,
        Screens.s200,
        Screens.s300,
      ],
      ignoreWhenBusy: true,
    );
  }

  Future<void> toSet2() async {
    screenStackBackupSet1 = rubigoRouter.screenStackNotifier.value;
    await rubigoRouter.replaceStack(
      screenStackBackupSet2,
      ignoreWhenBusy: true,
    );
  }
}
