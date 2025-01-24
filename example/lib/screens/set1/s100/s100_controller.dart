import 'package:example/screens/screens.dart';
import 'package:rubigo_router/rubigo_router.dart';

class S100Controller with RubigoControllerMixin<Screens> {
  Future<void> onS110ButtonPressed() async {
    await rubigoRouter.push(Screens.s110, ignoreWhenBusy: true);
  }
}
