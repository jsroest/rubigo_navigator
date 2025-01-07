import 'package:example/screens/screens.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';

class S200Controller with RubigoController<Screens> {
  @override
  Future<void> onTop(RubigoChangeInfo<Screens> changeInfo) async {
    if (changeInfo.eventType == EventType.push) {
      // Simulate slow backend, demonstrate we are not able to push any buttons
      // while this is in progress. As opposed of consumer apps this is a
      // perfect fit for Line of Business apps
      await Future<void>.delayed(const Duration(seconds: 2));
    }
  }

  Future<void> onS300ButtonPressed() async {
    await rubigoRouter.whenNotBusy?.push(Screens.s300);
  }

  Future<void> onPopButtonPressed() async {
    await rubigoRouter.whenNotBusy?.pop();
  }
}
