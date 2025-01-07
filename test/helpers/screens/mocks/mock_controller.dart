import 'package:rubigo_navigator/rubigo_navigator.dart';

import 'callbacks.dart';

class MockController<SCREEN_ID extends Enum> with RubigoController<SCREEN_ID> {
  MockController({bool mayPop = true}) : _mayPop = mayPop;

  final bool _mayPop;

  @override
  Future<bool> mayPop() async {
    callBackHistory.add(MayPopCallBack());
    await super.mayPop(); //Call this only for code coverage
    return _mayPop;
  }

  @override
  Future<void> onTop(RubigoChangeInfo<SCREEN_ID> changeInfo) async {
    callBackHistory.add(OnTopCallBack(changeInfo));
    return super.onTop(changeInfo);
  }

  @override
  Future<void> willShow(RubigoChangeInfo<SCREEN_ID> changeInfo) async {
    callBackHistory.add(WillShowCallBack(changeInfo));
    return super.willShow(changeInfo);
  }

  @override
  Future<void> isShown(RubigoChangeInfo<SCREEN_ID> changeInfo) async {
    callBackHistory.add(IsShownCallBack(changeInfo));
    return super.isShown(changeInfo);
  }

  final List<CallBack> callBackHistory = [];
}
