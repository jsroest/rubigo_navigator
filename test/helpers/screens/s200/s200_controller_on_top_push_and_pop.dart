import 'package:rubigo_navigator/rubigo_navigator.dart';

import '../screens.dart';

class S200ControllerOnTopPushAndPop extends RubigoController<Screens> {
  @override
  Future<void> onTop(RubigoChangeInfo<Screens?> changeInfo) async {
    //Here you can set conditions to push the next screen on the stack in one go.
    if (changeInfo.stackChange == StackChange.isPushed &&
        changeInfo.previousScreen == Screens.s100) {
      await navigator.push(Screens.s300);
      return;
    }
    //Here you can set conditions to also pop this screen from the stack in one go.
    if (changeInfo.stackChange == StackChange.isRevealed &&
        changeInfo.previousScreen == Screens.s300) {
      await navigator.pop();
    }
  }
}
