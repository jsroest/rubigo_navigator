import 'package:example/screens/screens.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';

class S500Controller with RubigoController<Screens> {
  bool get canPop => true;

  Future<void> onS600ButtonPressed() async {
    await navigator.push(Screens.s600);
  }

  Future<void> replaceStack() async {
    await navigator.replaceStack(
      [
        Screens.s100,
        Screens.s200,
        Screens.s300,
      ],
    );
  }
}
