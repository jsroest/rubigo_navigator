import '../mocks/mock_controller.dart';

class S200ControllerMayPopReturnsFalse extends MockController {
  @override
  Future<bool> mayPop() async {
    return false;
  }
}
