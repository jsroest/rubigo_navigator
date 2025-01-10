import 'package:rubigo_navigator/rubigo_navigator.dart';

import '../mocks/mock_controller.dart';
import '../screens.dart';

class S200ControllerOnTopPushAndPop extends MockController<Screens> {
  @override
  Future<void> onTop(RubigoChangeInfo<Screens> changeInfo) async {
    await super.onTop(changeInfo);
    //Here you can set conditions to push the next screen on the stack in one
    // go.
    if (changeInfo.eventType == EventType.push &&
        changeInfo.previousScreen == Screens.s100) {
      await rubigoRouter.push(Screens.s300);
      return;
    }
    //Here you can set conditions to also pop this screen from the stack in one
    // go.
    if (changeInfo.eventType == EventType.pop &&
        changeInfo.previousScreen == Screens.s300) {
      await rubigoRouter.pop();
    }
  }
}
