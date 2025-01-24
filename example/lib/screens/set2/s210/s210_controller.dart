import 'package:example/screens/screens.dart';
import 'package:rubigo_router/rubigo_router.dart';

class S210Controller with RubigoControllerMixin<Screens> {
  Future<void> onS220ButtonPressed() async {
    await rubigoRouter.push(Screens.s220, ignoreWhenBusy: true);
  }

  Future<void> onPopButtonPressed() async {
    await rubigoRouter.pop(ignoreWhenBusy: true);
  }
}
