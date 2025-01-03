import 'package:example/screens/screens.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';

class S600Controller with RubigoController<Screens> {
  Future<void> onS700ButtonPressed() async {
    await rubigoRouter.whenNotBusy?.push(Screens.s700);
  }

  Future<void> onPopButtonPressed() async {
    await rubigoRouter.whenNotBusy?.pop();
  }
}
