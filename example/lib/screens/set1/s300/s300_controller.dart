import 'package:example/screens/screens.dart';
import 'package:example/screens/set1/screen_stack_backup_set1.dart';
import 'package:example/screens/set2/screen_stack_backup_set2.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';

class S300Controller with RubigoController<Screens> {
  @override
  Future<void> onTop(RubigoChangeInfo<Screens?> changeInfo) async {
    if (changeInfo.eventType == EventType.push) {
      // Simulate slow backend, demonstrate we are not able to push any buttons
      // while this is in progress. As opposed of consumer apps this is a
      // perfect fit for Line of Business apps
      await Future<void>.delayed(const Duration(seconds: 2));
    }
  }

  Future<void> onPopButtonPressed() async {
    await rubigoRouter.whenNotBusy?.pop();
  }

  Future<void> onPopToS100ButtonPressed() async {
    await rubigoRouter.whenNotBusy?.popTo(Screens.s100);
  }

  Future<void> onRemoveS200ButtonPressed() async {
    rubigoRouter.whenNotBusy?.remove(Screens.s200);
  }

  Future<void> onRemoveS100ButtonPressed() async {
    rubigoRouter.whenNotBusy?.remove(Screens.s100);
  }

  Future<void> resetStack() async {
    await rubigoRouter.whenNotBusy?.replaceStack([
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
