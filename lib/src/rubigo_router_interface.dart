import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:rubigo_navigator/src/rubigo_screen.dart';

abstract class RubigoRouterInterface<SCREEN_ID extends Enum>
    with ChangeNotifier {
  List<RubigoScreen<SCREEN_ID>> get screens;

  Future<void> pop();

  Future<void> popTo(SCREEN_ID screenId);

  Future<void> push(SCREEN_ID screenId);

  Future<void> replaceStack(List<SCREEN_ID> screens);

  void remove(SCREEN_ID screenId);
}
