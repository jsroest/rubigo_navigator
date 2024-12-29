import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rubigo_navigator/src/extensions/extensions.dart';
import 'package:rubigo_navigator/src/mixins/rubigo_screen_mixin.dart';
import 'package:rubigo_navigator/src/rubigo_controller.dart';
import 'package:rubigo_navigator/src/rubigo_screen.dart';
import 'package:rubigo_navigator/src/stack_manager/rubigo_stack_manager.dart';
import 'package:rubigo_navigator/src/stack_manager/rubigo_stack_manager_interface.dart';
import 'package:rubigo_navigator/src/types/rubigo_type_definitions.dart';

class RubigoRouter<SCREEN_ID extends Enum>
    with ChangeNotifier
    implements
        RubigoStackManagerInterface<SCREEN_ID, RubigoController<SCREEN_ID>> {
  void init({
    required List<SCREEN_ID> initialScreenStack,
    required ListOfRubigoScreens<SCREEN_ID> availableScreens,
    RubigoStackManagerInterface<SCREEN_ID, RubigoController<SCREEN_ID>>?
        rubigoStackManager,
    LogNavigation? logNavigation,
  }) {
    logNavigation ??= (message) async => debugPrint(message);
    rubigoStackManager ??= RubigoStackManager<SCREEN_ID>(
      initialScreenStack.toListOfRubigoScreen(availableScreens),
      availableScreens,
      logNavigation,
    );

    rubigoStackManager.addListener(notifyListeners);
    _rubigoStackManager = rubigoStackManager;

    for (final screenSet in availableScreens) {
      //Wire up the controller in each screenWidget that has the RubigoControllerMixin
      final screenWidget = screenSet.screenWidget;
      if (screenWidget is RubigoScreenMixin) {
        (screenWidget as RubigoScreenMixin).controller = screenSet.controller;
      }
    }
  }

  late RubigoStackManagerInterface<SCREEN_ID, RubigoController<SCREEN_ID>>
      _rubigoStackManager;

  @override
  List<RubigoScreen<SCREEN_ID>> get screens => _rubigoStackManager.screens;

  @override
  Future<void> pop() => _rubigoStackManager.pop();

  @override
  Future<void> popTo(SCREEN_ID screenId) => _rubigoStackManager.popTo(screenId);

  @override
  Future<void> push(SCREEN_ID screenId) => _rubigoStackManager.push(screenId);

  @override
  Future<void> onDidRemovePage(Page<Object?> page) =>
      _rubigoStackManager.onDidRemovePage(page);

  @override
  Future<void> replaceStack(List<SCREEN_ID> screens) =>
      _rubigoStackManager.replaceStack(screens);

  @override
  void remove(SCREEN_ID screenId) => _rubigoStackManager.remove(screenId);

  @override
  bool hasScreenBelow() => _rubigoStackManager.hasScreenBelow();

  @override
  bool onPopPage(Route<dynamic> route, dynamic result) =>
      _rubigoStackManager.onPopPage(route, result);
}
