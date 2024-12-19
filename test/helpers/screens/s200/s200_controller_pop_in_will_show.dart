import 'package:rubigo_navigator/rubigo_navigator.dart';

import '../screens.dart';

class S200ControllerPopInWillShow extends RubigoController<Screens> {
  @override
  Future<void> willShow(RubigoChangeInfo<Screens?> changeInfo) async {
    await navigator.pop();
  }
}
