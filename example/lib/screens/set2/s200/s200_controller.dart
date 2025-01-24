import 'package:example/screens/screens.dart';
import 'package:rubigo_router/rubigo_router.dart';

class S200Controller with RubigoControllerMixin<Screens> {
  Future<void> onS210ButtonPressed() async {
    await rubigoRouter.push(Screens.s210, ignoreWhenBusy: true);
  }
}
