import 'package:flutter/foundation.dart';
import 'package:rubigo_router/rubigo_router.dart';

sealed class CallBack {}

@immutable
class MayPopCallBack extends CallBack {
  MayPopCallBack({required this.mayPop});

  final bool mayPop;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MayPopCallBack &&
        runtimeType == other.runtimeType &&
        mayPop == other.mayPop;
  }

  @override
  int get hashCode => mayPop.hashCode;
}

@immutable
class _ChangeInfoCallBack<SCREEN_ID extends Enum> extends CallBack {
  _ChangeInfoCallBack(this.changeInfo);

  final RubigoChangeInfo<SCREEN_ID> changeInfo;

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
