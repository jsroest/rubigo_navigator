import 'package:flutter/foundation.dart';
import 'package:rubigo_router/rubigo_router.dart';

import '../screens.dart';
import 'callbacks.dart';

class MockController with RubigoControllerMixin<Screens> {
  Screens? onTopPush;
  Screens? willShowPush;
  Screens? removedFromStackPush;
  bool mayPopValue = true;
  final List<CallBack> callBackHistory = [];

  @mustCallSuper
  @override
  Future<void> onTop(RubigoChangeInfo<Screens> changeInfo) async {
    await super.onTop(changeInfo);
    callBackHistory.add(OnTopCallBack(changeInfo));
    if (onTopPush != null) {
      await rubigoRouter.prog.push(onTopPush!);
    }
  }

  @mustCallSuper
  @override
  Future<void> willShow(RubigoChangeInfo<Screens> changeInfo) async {
    await super.willShow(changeInfo);
    callBackHistory.add(WillShowCallBack(changeInfo));
    if (willShowPush != null) {
      await rubigoRouter.prog.push(willShowPush!);
    }
  }

  @mustCallSuper
  @override
  Future<void> removedFromStack() async {
    await super.removedFromStack();
    callBackHistory.add(RemovedFromStackCallBack());
    if (removedFromStackPush != null) {
      await rubigoRouter.prog.push(removedFromStackPush!);
    }
  }

  @mustCallSuper
  @override
  Future<bool> mayPop() async {
    await super.mayPop();
    callBackHistory.add(MayPopCallBack(mayPop: mayPopValue));
    return mayPopValue;
  }
}
