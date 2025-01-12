import 'package:example/screens/screens.dart';
import 'package:rubigo_router/rubigo_router.dart';

class S600Controller with RubigoControllerMixin<Screens> {
  Future<void> onS700ButtonPressed() async {
    await rubigoRouter.push(Screens.s700, ignoreWhenBusy: true);
  }

  Future<void> onPopButtonPressed() async {
    await rubigoRouter.pop(ignoreWhenBusy: true);
  }
}
