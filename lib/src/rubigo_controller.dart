import 'package:rubigo_navigator/src/rubigo_change_info.dart';
import 'package:rubigo_navigator/src/rubigo_router.dart';

mixin RubigoController<SCREEN_ID extends Enum> {
  late RubigoRouter<SCREEN_ID> rubigoRouter;

  Future<void> onTop(RubigoChangeInfo<SCREEN_ID> changeInfo) async {}

  Future<void> willShow(RubigoChangeInfo<SCREEN_ID> changeInfo) async {}

  Future<void> isShown(RubigoChangeInfo<SCREEN_ID> changeInfo) async {}

  Future<bool> mayPop() => Future.value(true);
}
