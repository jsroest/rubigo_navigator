import 'package:flutter/foundation.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';

import '../screens.dart';

sealed class CallBack {}

class MayPopCallBack extends CallBack {}

@immutable
class _ChangeInfoCallBack extends CallBack {
  _ChangeInfoCallBack(this.changeInfo);

  final RubigoChangeInfo<Screens> changeInfo;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is _ChangeInfoCallBack &&
        runtimeType == other.runtimeType &&
        changeInfo == other.changeInfo;
  }

  @override
  int get hashCode => changeInfo.hashCode;
}

class OnTopCallBack extends _ChangeInfoCallBack {
  OnTopCallBack(super.changeInfo);
}

class WillShowCallBack extends _ChangeInfoCallBack {
  WillShowCallBack(super.changeInfo);
}

class IsShownCallBack extends _ChangeInfoCallBack {
  IsShownCallBack(super.changeInfo);
}
