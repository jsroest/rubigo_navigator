import 'package:example/screens/screens.dart';
import 'package:rubigo_router/rubigo_router.dart';

class S120Controller with RubigoControllerMixin<Screens> {
  Future<void> onS130ButtonPressed() async {
    await rubigoRouter.ui.push(Screens.s130);
  }

  Future<void> onPopButtonPressed() async {
    await rubigoRouter.ui.pop();
  }
}
