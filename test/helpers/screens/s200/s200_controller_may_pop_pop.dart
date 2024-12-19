import 'package:rubigo_navigator/rubigo_navigator.dart';

import '../screens.dart';

class S200ControllerMayPopPop extends RubigoController<Screens> {
  @override
  Future<bool> mayPop() async {
    await navigator.push(Screens.s300);
    return false;
  }
}
