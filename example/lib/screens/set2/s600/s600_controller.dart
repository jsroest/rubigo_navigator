import 'package:example/dependency_injection.dart';
import 'package:example/screens/screens.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';

class S600Controller with RubigoController<Screens> {
  Future<void> onS700ButtonPressed() async {
    await rubigoRouter.push(Screens.s700);
  }

  Future<void> onBackButtonPressed() async {
    await rubigoRouter.pop();
  }
}
