import 'package:flutter/material.dart';
import 'package:rubigo_navigator/src/rubigo_screen.dart';
import 'package:rubigo_navigator/src/types/rubigo_type_definitions.dart';

/// A collection of extension methods on ListOfRubigoScreens
extension ExtensionOnListOfRubigoScreens<SCREEN_ID extends Enum>
    on ListOfRubigoScreens<SCREEN_ID> {
  /// Finds the first RubigoScreen in the list with this screenId.
  /// This function throws an error if the screen is not found.
  RubigoScreen<SCREEN_ID> find(SCREEN_ID screenId) =>
      firstWhere((e) => e.screenId == screenId);

  /// Finds the first RubigoScreen in the list with this screenId
  /// and returns it's corresponding screenWidget.
  /// This function throws an error if the screen is not found.
  Widget findScreenWidget(SCREEN_ID screenId) => find(screenId).screenWidget;

  /// Converts this list to a list of ScreenIdl
  List<SCREEN_ID> toListOfScreenId() => map((e) => e.screenId).toList();

  /// Converts this list to a list of screenWidgets
  List<Widget> toListOfWidget() => map((e) => e.screenWidget).toList();
}

extension ExtensionOnListOfScreenId<SCREEN_ID extends Enum> on List<SCREEN_ID> {
  bool hasScreenBelow() => length > 1;

  bool containsScreenBelow(SCREEN_ID screenId) {
    final lastPageIndex = length - 1;
    final belowLastPageIndex = lastPageIndex - 1;
    final indexFound = lastIndexOf(screenId, belowLastPageIndex);
    return indexFound != -1;
  }

  List<Widget> toListOfWidget(ListOfRubigoScreens availableScreens) =>
      map((screenId) => availableScreens.findScreenWidget(screenId)).toList();

  List<RubigoScreen<SCREEN_ID>> toListOfRubigoScreen(
    ListOfRubigoScreens<SCREEN_ID> availableScreens,
  ) =>
      map((screenId) => availableScreens.find(screenId)).toList();

  String printBreadCrumbs() => map((e) => e.name).join('→').toUpperCase();
}
