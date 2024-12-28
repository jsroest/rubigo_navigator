import 'package:example/screens/screens.dart';
import 'package:example/screens/set1/set1_state.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';

class S100Controller with RubigoController<Screens> {
  bool get canPop => true;

  Future<void> onS200ButtonPressed() async {
    await navigator.push(Screens.s200);
  }
}
