import 'package:rubigo_navigator/rubigo_navigator.dart';

import '../../dependency_injection.dart';
import '../screens.dart';

class S200ControllerWillShowPush with RubigoController<Screens> {
  @override
  Future<void> willShow(RubigoChangeInfo<Screens?> changeInfo) async {
    await rubigoRouter.push(Screens.s300);
  }
}
