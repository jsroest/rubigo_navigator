import 'package:example/screens/screens.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';

class S200Controller with RubigoController<Screens> {
  bool get canPop => true;

  Future<void> onS300ButtonPressed() async {
    await rubigoRouter.push(Screens.s300);
  }

  Future<void> onBackButtonPressed() async {
    await rubigoRouter.pop();
  }
}
