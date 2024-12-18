import 'package:flutter/material.dart';
import 'package:rubigo_navigator/src/rubigo_controller.dart';
import 'package:rubigo_navigator/src/types/rubigo_type_definitions.dart';

extension ExtensionOnListOfRubigoScreens<SCREEN_ID extends Enum>
    on ListOfRubigoScreens {
  RubigoController<SCREEN_ID> findController(SCREEN_ID screenId) =>
      firstWhere((e) => e.screenId == screenId).controller
          as RubigoController<SCREEN_ID>;

  CONTROLLER findSpecificController<CONTROLLER>(SCREEN_ID screenId) =>
      firstWhere((e) => e.screenId == screenId).controller as CONTROLLER;

  Widget findScreen(SCREEN_ID screenId) =>
      firstWhere((e) => e.screenId == screenId).screen;

  SCREEN_ID findScreenIdByScreen(Widget screen) =>
      firstWhere((e) => e.screen == screen).screenId as SCREEN_ID;
}

extension ExtensionOnListOfScreenId on List<Enum> {
  List<Widget> toListOfWidget(ListOfRubigoScreens availableScreens) =>
      map((screenId) => availableScreens.findScreen(screenId)).toList();
}
