import 'package:flutter/widgets.dart';
import 'package:rubigo_navigator/src/rubigo_controller.dart';

class RubigoScreen<SCREEN_ID extends Enum> {
  RubigoScreen(
    this.screenId,
    this.screenWidget,
    this.controller,
  ) : pageKey = ValueKey(screenId);

  final ValueKey<SCREEN_ID> pageKey;
  final SCREEN_ID screenId;
  final Widget screenWidget;
  final RubigoController<SCREEN_ID> controller;
}
