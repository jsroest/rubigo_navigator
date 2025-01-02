import 'package:example/screens/screens.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';

class S500Controller with RubigoController<Screens> {
  Future<void> onS600ButtonPressed() async {
    await rubigoRouter.whenNotBusy?.push(Screens.s600);
  }
}
