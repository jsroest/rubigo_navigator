import 'package:demo_rubigo_navigator/screens/screens.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';

class S200Controller extends RubigoController<Screens> {
  Future<void> onS300ButtonPressed() async {
    await navigator.push(Screens.s300);
  }

  Future<void> onBackButtonPressed() async {
    await navigator.pop();
  }
}
