import '../mocks/mock_controller.dart';

class S200ControllerMayPopPush extends MockController {
  @override
  Future<bool> mayPop() async {
    await rubigoRouter.pop();
    return false;
  }
}
