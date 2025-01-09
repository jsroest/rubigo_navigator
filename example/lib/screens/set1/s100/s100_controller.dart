import 'package:example/screens/screens.dart';
import 'package:example/widgets/are_you_sure.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';

class S100Controller with RubigoController<Screens> {
  Future<void> onS200ButtonPressed() async {
    if (rubigoRouter.rubigoBusy.isBusy) {
      return;
    }
    if (await areYouSure(rubigoRouter)) {
      await rubigoRouter.push(Screens.s200, ignoreWhenBusy: true);
    }
  }
}
