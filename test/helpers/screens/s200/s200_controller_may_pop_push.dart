import '../mocks/mock_controller.dart';
import '../screens.dart';

class S200ControllerMayPopPush extends MockController<Screens> {
  S200ControllerMayPopPush() : super(mayPop: false);

  @override
  Future<bool> mayPop() async {
    final result = super.mayPop();
    await rubigoRouter.pop();
    return result;
  }
}
