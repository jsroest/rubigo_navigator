import 'package:example/dependency_injection.dart';
import 'package:example/screens/screens.dart';
import 'package:example/screens/set1/screen_stack_backup_set1.dart';
import 'package:example/screens/set2/screen_stack_backup_set2.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';

class S300Controller with RubigoController<Screens> {
  Future<void> onPopButtonPressed() async {
    await rubigoRouter.pop();
  }

  Future<void> onPopToS100ButtonPressed() async {
    await rubigoRouter.popTo(Screens.s100);
  }

  Future<void> onRemoveS200ButtonPressed() async {
    rubigoRouter.remove(Screens.s200);
  }

  Future<void> onRemoveS100ButtonPressed() async {
    rubigoRouter.remove(Screens.s100);
  }

  Future<void> resetStack() async {
    await rubigoRouter.replaceStack([
      Screens.s100,
      Screens.s200,
      Screens.s300,
    ]);
  }

  Future<void> toSet2() async {
    screenStackBackupSet1 = rubigoRouter.screenStackNotifier.value;
    await rubigoRouter.replaceStack(screenStackBackupSet2);
  }
}
