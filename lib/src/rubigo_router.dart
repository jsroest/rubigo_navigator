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
  RubigoRouter({
    required this.splashWidget,
    required this.protect,
  });

  Future<void> init({
    required Future<SCREEN_ID> Function() getFirstScreenAsync,
    required ListOfRubigoScreens<SCREEN_ID> availableScreens,
    RubigoStackManagerInterface<SCREEN_ID, RubigoController<SCREEN_ID>>?
        rubigoStackManager,
    LogNavigation? logNavigation,
  }) async {
    final firstScreen = await getFirstScreenAsync();
    logNavigation ??= (message) async => debugPrint(message);
    rubigoStackManager ??= RubigoStackManager<SCREEN_ID>(
      [firstScreen].toListOfRubigoScreen(availableScreens),
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

    _isInitialized = true;
    notifyListeners();
  }

  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  final Widget splashWidget;

  late RubigoStackManagerInterface<SCREEN_ID, RubigoController<SCREEN_ID>>
      _rubigoStackManager;

  final Future<T> Function<T>(Future<T> Function() function) protect;

  @override
  List<RubigoScreen<SCREEN_ID>> get screens => _rubigoStackManager.screens;

  @override
  Future<void> pop() => protect(() => _rubigoStackManager.pop());

  @override
  Future<void> popTo(SCREEN_ID screenId) =>
      protect(() => _rubigoStackManager.popTo(screenId));

  @override
  Future<void> push(SCREEN_ID screenId) =>
      protect(() => _rubigoStackManager.push(screenId));

  @override
  Future<void> onDidRemovePage(Page<Object?> page) =>
      protect(() => _rubigoStackManager.onDidRemovePage(page));

  @override
  Future<void> replaceStack(List<SCREEN_ID> screens) =>
      protect(() => _rubigoStackManager.replaceStack(screens));

  @override
  void remove(SCREEN_ID screenId) => _rubigoStackManager.remove(screenId);

  @override
  bool onPopPage(Route<dynamic> route, dynamic result) =>
      _rubigoStackManager.onPopPage(route, result);
}
