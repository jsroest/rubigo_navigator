import 'package:example/screens/screens.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';

class S500Controller with RubigoController<Screens> {
  bool get canPop => true;

  Future<void> onS600ButtonPressed() async {
    await rubigoRouter.push(Screens.s600);
  }
}
