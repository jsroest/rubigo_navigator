import 'package:example/screens/screens.dart';
import 'package:example/screens/set1/set1_state.dart';
import 'package:example/screens/set2/set2_state.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';

class S300Controller with RubigoController<Screens> {
  Future<void> onPopButtonPressed() async {
    await rubigoRouter.pop();
  }

  Future<void> onPopToS100ButtonPressed() async {
    await rubigoRouter.popTo(Screens.s100);
  }

  Future<void> onRemoveS200ButtonPressed() async {
    rubigoRouter.remove(Screens.s200);
  }

  Future<void> onRemoveS100ButtonPressed() async {
    rubigoRouter.remove(Screens.s100);
  }

  Future<void> toSet2() async {
    screenStackSet1 = rubigoRouter.screens.toListOfScreenId();
    await rubigoRouter.replaceStack(screenStackSet2);
  }
}
