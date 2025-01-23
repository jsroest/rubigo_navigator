import 'package:flutter/foundation.dart';
import 'package:rubigo_router/rubigo_router.dart';

import 'callbacks.dart';

class MockController<SCREEN_ID extends Enum>
    with RubigoControllerMixin<SCREEN_ID> {
  MockController({bool mayPop = true}) : _mayPop = mayPop;

  final bool _mayPop;

  @mustCallSuper
  @override
  Future<bool> mayPop() async {
    await super.mayPop(); //Call this only for code coverage
    callBackHistory.add(MayPopCallBack(mayPop: _mayPop));
    return _mayPop;
  }

  @mustCallSuper
  @override
  Future<void> onTop(RubigoChangeInfo<SCREEN_ID> changeInfo) async {
    callBackHistory.add(OnTopCallBack(changeInfo));
    return super.onTop(changeInfo);
  }

  @mustCallSuper
  @override
  Future<void> willShow(RubigoChangeInfo<SCREEN_ID> changeInfo) async {
    callBackHistory.add(WillShowCallBack(changeInfo));
    return super.willShow(changeInfo);
  }

  final List<CallBack> callBackHistory = [];
}
