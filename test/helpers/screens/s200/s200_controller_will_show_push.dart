import 'package:rubigo_navigator/rubigo_navigator.dart';

import '../mocks/mock_controller.dart';
import '../screens.dart';

class S200ControllerWillShowPush extends MockController<Screens> {
  @override
  Future<void> willShow(RubigoChangeInfo<Screens> changeInfo) async {
    await super.willShow(changeInfo);
    await rubigoRouter.push(Screens.s300);
  }
}
