import '../mocks/mock_controller.dart';
import '../screens.dart';

class S200ControllerMayPopPush extends MockController<Screens> {
  @override
  Future<bool> mayPop() async {
    await rubigoRouter.pop();
    return false;
  }
}
