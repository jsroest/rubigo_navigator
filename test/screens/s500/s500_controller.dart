import '../mocks/mock_controller.dart';

class S500RubigoController extends MockController {
  @override
  Future<bool> mayPop() async {
    await super.mayPop();
    return false;
  }
}

class S400Controller {}
