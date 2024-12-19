import 'package:rubigo_navigator/rubigo_navigator.dart';

import '../screens.dart';

class S200ControllerWillShowPop with RubigoController<Screens> {
  @override
  Future<void> willShow(RubigoChangeInfo<Screens?> changeInfo) async {
    await navigator.pop();
  }
}
