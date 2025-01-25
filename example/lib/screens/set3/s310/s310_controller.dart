import 'package:example/screens/screens.dart';
import 'package:rubigo_router/rubigo_router.dart';

class S310Controller with RubigoControllerMixin<Screens> {
  Future<void> onS320ButtonPressed() async {
    await rubigoRouter.ui.push(Screens.s320);
  }

  Future<void> onPopButtonPressed() async {
    await rubigoRouter.ui.pop();
  }
}
