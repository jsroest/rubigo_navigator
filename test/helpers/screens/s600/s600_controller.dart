import 'package:rubigo_router/rubigo_router.dart';

import '../mocks/mock_controller.dart';
import '../screens.dart';

class S600Controller extends MockController<Screens> {
  @override
  Future<void> willShow(RubigoChangeInfo<Screens> changeInfo) async {
    await rubigoRouter.prog.push(Screens.s700);
    //This will throw, because we are in willShow
    return super.willShow(changeInfo);
  }
}
