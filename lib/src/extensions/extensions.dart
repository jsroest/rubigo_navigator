import 'package:flutter/material.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';

extension ExtensionOnListOfRubigoScreens<SCREEN_ID extends Enum>
    on ListOfRubigoScreens<SCREEN_ID> {
  Widget findScreen(SCREEN_ID screenId) =>
      firstWhere((e) => e.screenId == screenId).screenWidget;

  List<SCREEN_ID> toListOfScreenId() => map((e) => e.screenId).toList();

  RubigoScreen<SCREEN_ID> findByScreenId(SCREEN_ID screenId) =>
      firstWhere((e) => e.screenId == screenId);

  String printStack() => map((e) => e.screenId.name).toList().join(' => ');
}

extension ExtensionOnListOfScreenId<SCREEN_ID extends Enum> on List<SCREEN_ID> {
  bool hasScreenBelow() => length > 1;

  bool containsScreenBelow(SCREEN_ID screenId) =>
      lastIndexWhere((e) => e == screenId, length - 1) != -1;

  List<Widget> toListOfWidget(ListOfRubigoScreens availableScreens) =>
      map((screenId) => availableScreens.findScreen(screenId)).toList();

  List<RubigoScreen<SCREEN_ID>> toListOfRubigoScreen(
    ListOfRubigoScreens<SCREEN_ID> availableScreens,
  ) =>
      map((screenId) => availableScreens.findByScreenId(screenId)).toList();
}
