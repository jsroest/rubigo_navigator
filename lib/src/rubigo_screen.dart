import 'package:flutter/widgets.dart';
import 'package:rubigo_navigator/src/rubigo_controller.dart';

class RubigoScreen<SCREEN_ID extends Enum,
    RUBIGO_CONTROLLER extends RubigoController<SCREEN_ID>> {
  RubigoScreen(
    this.screenId,
    this.screen,
    this.controller,
  );

  final SCREEN_ID screenId;
  final Widget screen;
  final RUBIGO_CONTROLLER controller;
}
