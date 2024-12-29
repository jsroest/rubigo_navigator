import 'package:example/dependency_injection.dart';
import 'package:example/screens/screens.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';

class S100Controller with RubigoController<Screens> {
  Future<void> onS200ButtonPressed() async {
    await rubigoRouter.push(Screens.s200);
  }
}
