import 'dart:async';

import 'package:flutter/widgets.dart';
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
    required this.availableScreens,
    required this.splashScreenId,
    ProtectWrapper? protectWrapper,
  }) : protectWrapper = protectWrapper ??=
            ((Future<void> Function() function) => function());

  Future<void> init({
    required Future<SCREEN_ID> Function() getFirstScreenAsync,
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

  // bool get isInitialized => _isInitialized;

  final SCREEN_ID splashScreenId;
  final ListOfRubigoScreens<SCREEN_ID> availableScreens;

  late RubigoStackManagerInterface<SCREEN_ID, RubigoController<SCREEN_ID>>
      _rubigoStackManager;

  // This function can be used to protect the app from user input while navigating.
  final ProtectWrapper protectWrapper;

  @override
  ValueNotifier<List<SCREEN_ID>> get screenStackNotifier =>
      _rubigoStackManager.screenStackNotifier;

  @override
  List<RubigoScreen<SCREEN_ID>> get screens => _isInitialized
      ? _rubigoStackManager.screens
      : [availableScreens.findByScreenId(splashScreenId)];

  @override
  Future<void> pop() => protectWrapper(() => _rubigoStackManager.pop());

  @override
  Future<void> popTo(SCREEN_ID screenId) =>
      protectWrapper(() => _rubigoStackManager.popTo(screenId));

  @override
  Future<void> push(SCREEN_ID screenId) =>
      protectWrapper(() => _rubigoStackManager.push(screenId));

  @override
  Future<void> onDidRemovePage(Page<Object?> page) =>
      protectWrapper(() => _rubigoStackManager.onDidRemovePage(page));

  @override
  Future<void> replaceStack(List<SCREEN_ID> screens) =>
      protectWrapper(() => _rubigoStackManager.replaceStack(screens));

  @override
  void remove(SCREEN_ID screenId) => _rubigoStackManager.remove(screenId);

  @override
  bool onPopPage(Route<dynamic> route, dynamic result) =>
      _rubigoStackManager.onPopPage(route, result);
}
