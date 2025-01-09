import '../mocks/mock_controller.dart';
import '../screens.dart';

class S200ControllerMayPopPop extends MockController<Screens> {
  S200ControllerMayPopPop() : super(mayPop: false);

  @override
  Future<bool> mayPop() async {
    final result = super.mayPop();
    await rubigoRouter.push(Screens.s300);
    return result;
  }
}
