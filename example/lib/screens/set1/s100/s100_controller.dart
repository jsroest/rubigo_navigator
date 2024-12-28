import 'package:example/screens/screens.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';

class S100Controller with RubigoController<Screens> {
  bool get canPop => true;

  Future<void> onS200ButtonPressed() async {
    await navigator.push(Screens.s200);
  }

  Future<void> replaceStack() async {
    await navigator.replaceStack(
      [
        Screens.s500,
        Screens.s600,
        Screens.s700,
      ],
    );
  }
}
