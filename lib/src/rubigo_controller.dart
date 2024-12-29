mixin RubigoController<SCREEN_ID extends Enum> {
  Future<void> onTop(RubigoChangeInfo<SCREEN_ID?> changeInfo) async {}

  Future<void> willShow(RubigoChangeInfo<SCREEN_ID?> changeInfo) async {}

  Future<void> isShown(RubigoChangeInfo<SCREEN_ID?> changeInfo) async {}

  Future<bool> mayPop() => Future.value(true);

  bool get canPop => true;
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
