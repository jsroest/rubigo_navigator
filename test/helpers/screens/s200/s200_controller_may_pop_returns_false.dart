import 'package:rubigo_navigator/rubigo_navigator.dart';

import '../screens.dart';

class S200ControllerMayPopReturnsFalse with RubigoController<Screens> {
  @override
  Future<bool> mayPop() async {
    return false;
  }
}
