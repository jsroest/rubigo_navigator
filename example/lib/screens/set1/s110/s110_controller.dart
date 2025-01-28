import 'package:example/screens/screens.dart';
import 'package:rubigo_router/rubigo_router.dart';

class S110Controller with RubigoControllerMixin<Screens> {
  Future<void> onS120ButtonPressed() async {
    await rubigoRouter.ui.push(Screens.s120);
  }
}
