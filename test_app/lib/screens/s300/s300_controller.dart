import 'package:demo_rubigo_navigator/screens/screens.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';

class S300Controller extends RubigoController<Screens> {
  Future<void> onPopButtonPressed() async {
    await navigator.pop();
  }

  Future<void> onPopToS100ButtonPressed() async {
    await navigator.popTo(Screens.s100);
  }

  Future<void> onRemoveBelowButtonPressed() async {
    final pageBelow = navigator.screenStack[navigator.screenStack.length - 2];
    navigator.remove(pageBelow);
  }
}
