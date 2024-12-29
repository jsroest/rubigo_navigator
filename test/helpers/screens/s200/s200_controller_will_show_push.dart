import 'package:rubigo_navigator/rubigo_navigator.dart';

import '../../rubigo_router.dart';
import '../screens.dart';

class S200ControllerWillShowPush with RubigoController<Screens> {
  @override
  Future<void> willShow(RubigoChangeInfo<Screens?> changeInfo) async {
    await rubigoRouter.push(Screens.s300);
  }
}
