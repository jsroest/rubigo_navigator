import 'package:example/screens/screens.dart';
import 'package:example/screens/set1/set1_state.dart';
import 'package:example/screens/set2_state.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';

class S700Controller with RubigoController<Screens> {
  bool get canPop => true;

  Future<void> onPopButtonPressed() async {
    await rubigoRouter.pop();
  }

  Future<void> onPopToS500ButtonPressed() async {
    await rubigoRouter.popTo(Screens.s500);
  }

  Future<void> onRemoveS600ButtonPressed() async {
    rubigoRouter.remove(Screens.s600);
  }

  Future<void> onRemoveS500ButtonPressed() async {
    rubigoRouter.remove(Screens.s500);
  }

  Future<void> toSet1() async {
    screenStackSet2 = rubigoRouter.screens.toListOfScreenId();
    await rubigoRouter.replaceStack(screenStackSet1);
  }
}
