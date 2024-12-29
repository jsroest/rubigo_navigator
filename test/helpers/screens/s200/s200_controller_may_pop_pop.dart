import 'package:rubigo_navigator/rubigo_navigator.dart';

import '../../dependency_injection.dart';
import '../screens.dart';

class S200ControllerMayPopPop with RubigoController<Screens> {
  @override
  Future<bool> mayPop() async {
    await rubigoRouter.push(Screens.s300);
    return false;
  }
}
