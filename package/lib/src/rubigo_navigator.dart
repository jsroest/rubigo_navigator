import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rubigo_navigator/src/extensions/extensions.dart';
import 'package:rubigo_navigator/src/mixins/rubigo_controller_mixin.dart';
import 'package:rubigo_navigator/src/rubigo_controller.dart';
import 'package:rubigo_navigator/src/stack_manager/rubigo_stack_manager.dart';
import 'package:rubigo_navigator/src/stack_manager/rubigo_stack_manager_interface.dart';
import 'package:rubigo_navigator/src/types/rubigo_type_definitions.dart';

class RubigoNavigator<SCREEN_ID extends Enum>
    with ChangeNotifier
    implements RubigoStackManagerInterface<SCREEN_ID> {
  //This constructor creates a new RubigoNavigator and wires up the components
  factory RubigoNavigator({
    required List<SCREEN_ID> initialScreenStack,
    required ListOfRubigoScreens<SCREEN_ID> availableScreens,
    RubigoStackManagerInterface<SCREEN_ID>? rubigoStackManager,
    LogNavigation? logNavigation,
  }) {
    logNavigation ??= (message) async => debugPrint(message);
    rubigoStackManager ??= RubigoStackManager<SCREEN_ID>(
      initialScreenStack,
      availableScreens,
      logNavigation,
    );

    final navigator = RubigoNavigator._(rubigoStackManager, logNavigation);
    for (final screenSet in availableScreens) {
      //Wire up the controller in each screen that has the RubigoControllerMixin
      final screen = screenSet.screen;
      if (screen is RubigoControllerMixin) {
        (screen as RubigoControllerMixin).controller = screenSet.controller;
      }
      //Wire up the navigator in each controller
      screenSet.controller.navigator = navigator;
    }
    return navigator;
  }

  //Private constructor
  RubigoNavigator._(this._rubigoStackManager, this._logNavigation) {
    _rubigoStackManager.addListener(notifyListeners);
  }

  final RubigoStackManagerInterface<SCREEN_ID> _rubigoStackManager;
  final LogNavigation _logNavigation;

  //This function wraps a widget in a MaterialPage.
  //Override this functions if you want to use CupertinoPage's
  Page<void> screenToPage(Widget screen) => MaterialPage<void>(child: screen);

  //The list of pages to feed to the Flutter Navigator
  List<Page<void>> get pages {
    final screenStack = _rubigoStackManager.screenStack;
    unawaited(
      _logNavigation(
        'Screen stack: ${screenStack.map((e) => e.name).toList().join(', ')}',
      ),
    );
    final pages = screenStack
        .map(_rubigoStackManager.availableScreens.findScreen)
        .map(screenToPage)
        .toList();
    return pages;
  }

  //Use this function if you want access to a specific controller
  T getController<T extends RubigoController<SCREEN_ID>>(SCREEN_ID screenId) =>
      _rubigoStackManager.availableScreens.findSpecificController<T>(screenId);

  @override
  Future<void> pop() => _rubigoStackManager.pop();

  @override
  Future<void> popTo(SCREEN_ID screenId) => _rubigoStackManager.popTo(screenId);

  @override
  Future<void> push(SCREEN_ID screenId) => _rubigoStackManager.push(screenId);

  @override
  ListOfRubigoScreens<SCREEN_ID> get availableScreens =>
      _rubigoStackManager.availableScreens;

  @override
  List<SCREEN_ID> get screenStack => _rubigoStackManager.screenStack;

  @override
  void onDidRemovePage(Page<Object?> page) =>
      _rubigoStackManager.onDidRemovePage(page);

  @override
  void remove(SCREEN_ID screenId) => _rubigoStackManager.remove(screenId);
}
