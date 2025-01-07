import 'package:rubigo_navigator/src/rubigo_router.dart';

mixin RubigoController<SCREEN_ID extends Enum> {
  late RubigoRouter<SCREEN_ID> rubigoRouter;

  Future<void> onTop(RubigoChangeInfo<SCREEN_ID> changeInfo) async {}

  Future<void> willShow(RubigoChangeInfo<SCREEN_ID> changeInfo) async {}

  Future<void> isShown(RubigoChangeInfo<SCREEN_ID> changeInfo) async {}

  Future<bool> mayPop() => Future.value(true);
}

class RubigoChangeInfo<SCREEN_ID> {
  RubigoChangeInfo(
    this.eventType,
    this.previousScreen,
    this.screenStack,
  );

  final EventType eventType;
  final SCREEN_ID? previousScreen;
  final List<SCREEN_ID> screenStack;
}

enum EventType {
  push,
  pop,
  popTo,
  replaceStack,
}
