import 'package:example/screens/screens.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';

class S600Controller with RubigoController<Screens> {
  bool get canPop => true;

  Future<void> onS700ButtonPressed() async {
    await navigator.push(Screens.s700);
  }

  Future<void> onBackButtonPressed() async {
    await navigator.pop();
  }
}
