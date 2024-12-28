import 'package:example/screens/screens.dart';
import 'package:example/screens/set1/set1_state.dart';
import 'package:example/screens/set2_state.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';

class S300Controller with RubigoController<Screens> {
  bool get canPop => true;

  Future<void> onPopButtonPressed() async {
    await navigator.pop();
  }

  Future<void> onPopToS100ButtonPressed() async {
    await navigator.popTo(Screens.s100);
  }

  Future<void> onRemoveS200ButtonPressed() async {
    navigator.remove(Screens.s200);
  }

  Future<void> onRemoveS100ButtonPressed() async {
    navigator.remove(Screens.s100);
  }

  Future<void> toSet2() async {
    screenStackSet1 = navigator.screens.toListOfScreenId();
    await navigator.replaceStack(screenStackSet2);
  }
}
