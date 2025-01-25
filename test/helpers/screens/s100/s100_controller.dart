import '../mocks/mock_controller.dart';
import '../screens.dart';

class S100Controller extends MockController<Screens> {
  @override
  Future<bool> mayPop() async {
    await super.mayPop();
    return false;
  }
}
