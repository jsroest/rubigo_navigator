import '../mocks/mock_controller.dart';
import '../screens.dart';

class S200ControllerMayPopReturnsFalse extends MockController<Screens> {
  @override
  Future<bool> mayPop() async {
    return false;
  }
}
