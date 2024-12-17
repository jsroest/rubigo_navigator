import 'package:rubigo_navigator/src/extensions/extensions.dart';
import 'package:rubigo_navigator/src/rubigo_navigator.dart';

abstract class RubigoController<SCREEN_ID extends Enum> {
  Future<void> onTop(RubigoChangeInfo<SCREEN_ID?> changeInfo) async {}

  Future<void> willShow(RubigoChangeInfo<SCREEN_ID?> changeInfo) async {}

  Future<void> isShown(RubigoChangeInfo<SCREEN_ID?> changeInfo) async {}

  Future<bool> mayPop() => Future.value(true);

  bool get canPop {
    final firstController =
        navigator.availableScreens.findController(navigator.screenStack.first);
    if (this == firstController) {
      return false;
    }
    return true;
  }

  late final RubigoNavigator<SCREEN_ID> navigator;
}

class RubigoChangeInfo<SCREEN_ID> {
  RubigoChangeInfo(this.stackChange, this.previousScreen);

  final StackChange stackChange;
  final SCREEN_ID? previousScreen;
}

enum StackChange {
  isPushed,
  isRevealed,
}
