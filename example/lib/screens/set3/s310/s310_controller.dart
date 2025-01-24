import 'package:example/screens/screens.dart';
import 'package:rubigo_router/rubigo_router.dart';

class S310Controller with RubigoControllerMixin<Screens> {
  Future<void> onS320ButtonPressed() async {
    await rubigoRouter.push(Screens.s320, ignoreWhenBusy: true);
  }

  Future<void> onPopButtonPressed() async {
    await rubigoRouter.pop(ignoreWhenBusy: true);
  }
}
