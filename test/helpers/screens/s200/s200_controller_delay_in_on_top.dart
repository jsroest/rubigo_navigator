import 'package:rubigo_navigator/rubigo_navigator.dart';

import '../mocks/mock_controller.dart';
import '../screens.dart';

class S200ControllerDelayInOnTop extends MockController<Screens> {
  @override
  Future<void> onTop(RubigoChangeInfo<Screens> changeInfo) async {
    await super.onTop(changeInfo);
    await Future<void>.delayed(const Duration(milliseconds: 500));
  }
}
