import 'package:example/screens/screens.dart';
import 'package:rubigo_router/rubigo_router.dart';

class S220Controller with RubigoControllerMixin<Screens> {
  Future<void> onS230ButtonPressed() async {
    await rubigoRouter.ui.push(Screens.s230);
  }

  Future<void> onPopButtonPressed() async {
    await rubigoRouter.ui.pop();
  }
}
