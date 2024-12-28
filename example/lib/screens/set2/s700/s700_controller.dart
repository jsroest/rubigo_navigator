import 'package:example/screens/screens.dart';
import 'package:example/screens/set1/set1_state.dart';
import 'package:example/screens/set2_state.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';

class S700Controller with RubigoController<Screens> {
  bool get canPop => true;

  Future<void> onPopButtonPressed() async {
    await navigator.pop();
  }

  Future<void> onPopToS500ButtonPressed() async {
    await navigator.popTo(Screens.s500);
  }

  Future<void> onRemoveS600ButtonPressed() async {
    navigator.remove(Screens.s600);
  }

  Future<void> onRemoveS500ButtonPressed() async {
    navigator.remove(Screens.s500);
  }

  Future<void> toSet1() async {
    screenStackSet2 = navigator.screens.toListOfScreenId();
    await navigator.replaceStack(screenStackSet1);
  }
}
