import 'package:rubigo_navigator/rubigo_navigator.dart';

import '../screens.dart';
import 'callbacks.dart';

class MockController with RubigoController<Screens> {
  MockController({bool mayPop = true}) : _mayPop = mayPop;

  final bool _mayPop;

  @override
  Future<bool> mayPop() async {
    callBackHistory.add(MayPopCallBack());
    await super.mayPop(); //Call this only for code coverage
    return _mayPop;
  }

  @override
  Future<void> onTop(RubigoChangeInfo<Screens> changeInfo) async {
    callBackHistory.add(OnTopCallBack(changeInfo));
    return super.onTop(changeInfo);
  }

  @override
  Future<void> willShow(RubigoChangeInfo<Screens> changeInfo) async {
    callBackHistory.add(WillShowCallBack(changeInfo));
    return super.willShow(changeInfo);
  }

  @override
  Future<void> isShown(RubigoChangeInfo<Screens> changeInfo) async {
    callBackHistory.add(IsShownCallBack(changeInfo));
    return super.isShown(changeInfo);
  }

  final List<CallBack> callBackHistory = [];
}
