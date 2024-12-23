import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';

abstract class RubigoStackManagerInterface<SCREEN_ID extends Enum,
    RUBIGO_CONTROLLER extends RubigoController<SCREEN_ID>> with ChangeNotifier {
  List<RubigoScreen<SCREEN_ID>> get pages;

  Future<void> pop();

  Future<void> popTo(SCREEN_ID screenId);

  Future<void> push(SCREEN_ID screenId);

  Future<void> onDidRemovePage(Page<Object?> page);

  bool onPopPage(Route<dynamic> route, dynamic result);

  void remove(SCREEN_ID screenId);
}
