import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:rubigo_navigator/src/extensions/extensions.dart';
import 'package:rubigo_navigator/src/flutter/busy/rubigo_busy_service.dart';
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
    RubigoBusyService? rubigoBusyService,
    LogNavigation? logNavigation,
    RubigoStackManagerType<SCREEN_ID>? rubigoStackManager,
  })  : rubigoBusy = rubigoBusyService ?? RubigoBusyService(),
        _logNavigation =
            logNavigation ?? ((message) async => debugPrint(message)),
        _rubigoStackManager = rubigoStackManager ??
            RubigoStackManager(
              [availableScreens.findByScreenId(splashScreenId)],
              availableScreens,
              logNavigation ?? ((message) async => debugPrint(message)),
            );

  Future<void> init({
    required Future<SCREEN_ID> Function() getFirstScreenAsync,
    LogNavigation? logNavigation,
  }) async {
    _rubigoStackManager.addListener(notifyListeners);
    _rubigoStackManager.addListener(() {
      _screenStackNotifier.value =
          _rubigoStackManager.screens.toListOfScreenId();
    });

    for (final screenSet in availableScreens) {
      //Wire up the rubigoRouter in each controller
      final controller = screenSet.controller;
      controller.rubigoRouter = this;
      //Wire up the controller in each screenWidget that has the RubigoControllerMixin
      final screenWidget = screenSet.screenWidget;
      if (screenWidget is RubigoScreenMixin) {
        (screenWidget as RubigoScreenMixin).controller = screenSet.controller;
      }
    }
    final firstScreen = await getFirstScreenAsync();
    await _rubigoStackManager.replaceStack([firstScreen]);
  }

  final LogNavigation _logNavigation;
  final ListOfRubigoScreens<SCREEN_ID> availableScreens;
  final SCREEN_ID splashScreenId;
  final RubigoBusyService rubigoBusy;
  final RubigoStackManagerType<SCREEN_ID> _rubigoStackManager;

  late final _screenStackNotifier = ValueNotifier<List<SCREEN_ID>>(
    _rubigoStackManager.screens.toListOfScreenId(),
  );

  ValueNotifier<List<SCREEN_ID>> get screenStackNotifier =>
      _screenStackNotifier;

  @override
  List<RubigoScreen<SCREEN_ID>> get screens {
    final result = _rubigoStackManager.screens;
    unawaited(
      _logNavigation.call(
        'Screen stack: ${_screenStackNotifier.value.printBreadCrumbs()}.',
      ),
    );
    return result;
  }

  @override
  Future<void> pop() => rubigoBusy.busyWrapper(_rubigoStackManager.pop);

  @override
  Future<void> popTo(SCREEN_ID screenId) =>
      rubigoBusy.busyWrapper(() => _rubigoStackManager.popTo(screenId));

  @override
  Future<void> push(SCREEN_ID screenId) =>
      rubigoBusy.busyWrapper(() => _rubigoStackManager.push(screenId));

  @override
  Future<void> onDidRemovePage(Page<Object?> page) =>
      rubigoBusy.busyWrapper(() => _rubigoStackManager.onDidRemovePage(page));

  @override
  Future<void> replaceStack(List<SCREEN_ID> screens) =>
      rubigoBusy.busyWrapper(() => _rubigoStackManager.replaceStack(screens));

  @override
  void remove(SCREEN_ID screenId) => _rubigoStackManager.remove(screenId);

  @override
  bool onPopPage(Route<dynamic> route, dynamic result) =>
      _rubigoStackManager.onPopPage(route, result);

  RubigoRouter<SCREEN_ID>? get whenNotBusy =>
      rubigoBusy.notifier.value.isBusy ? null : this;
}
