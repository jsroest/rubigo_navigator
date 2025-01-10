import 'package:rubigo_router/rubigo_router.dart';

import '../mocks/mock_controller.dart';
import '../screens.dart';

class S200ControllerWillShowPop extends MockController<Screens> {
  @override
  Future<void> willShow(RubigoChangeInfo<Screens> changeInfo) async {
    await super.willShow(changeInfo);
    await rubigoRouter.pop();
  }
}
