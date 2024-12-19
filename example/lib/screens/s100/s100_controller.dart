import 'package:example/screens/screens.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';

class S100Controller extends RubigoController<Screens> {
  bool get canPop => true;

  Future<void> onS200ButtonPressed() async {
    await navigator.push(Screens.s200);
  }

  Future<void> onS300ButtonPressed() async {
    await navigator.push(Screens.s300);
  }
}
