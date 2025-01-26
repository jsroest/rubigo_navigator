import 'package:example/screens/screens.dart';
import 'package:example/widgets/are_you_sure.dart';
import 'package:rubigo_router/rubigo_router.dart';

class S110Controller with RubigoControllerMixin<Screens> {
  @override
  Future<void> onTop(RubigoChangeInfo<Screens> changeInfo) async {
    //Only execute this when we are pushed on top.
    if (changeInfo.eventType == EventType.push) {
      // Simulate slow backend, demonstrate we are not able to push any buttons
      // while this is in progress. As opposed of consumer apps this is a
      // perfect fit for Line of Business apps
      await Future<void>.delayed(const Duration(milliseconds: 500));
      if (!await areYouSure(rubigoRouter)) {
        await rubigoRouter.prog.pop();
      }
    }
  }

  Future<void> onS120ButtonPressed() async {
    await rubigoRouter.ui.push(Screens.s120);
  }

  Future<void> onPopButtonPressed() async {
    await rubigoRouter.ui.pop();
  }
}
