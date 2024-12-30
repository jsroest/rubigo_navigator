import 'package:example/dependency_injection.dart';
import 'package:example/screens/screens.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';

class S200Controller with RubigoController<Screens> {
  @override
  Future<void> onTop(RubigoChangeInfo<Screens?> changeInfo) async {
    //Simulate slow backend
    await Future<void>.delayed(const Duration(seconds: 2));
  }

  Future<void> onS300ButtonPressed() async {
    await rubigoRouter.push(Screens.s300);
  }

  Future<void> onPopButtonPressed() async {
    await rubigoRouter.pop();
  }
}
