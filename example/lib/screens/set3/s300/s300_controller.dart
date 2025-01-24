import 'package:example/screens/screens.dart';
import 'package:rubigo_router/rubigo_router.dart';

class S300Controller with RubigoControllerMixin<Screens> {
  Future<void> onS310ButtonPressed() async {
    await rubigoRouter.push(Screens.s310, ignoreWhenBusy: true);
  }
}
