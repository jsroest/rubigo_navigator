import 'package:example/screens/screens.dart';
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
}
