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
              [availableScreens.find(splashScreenId)],
              availableScreens,
              logNavigation ?? ((message) async => debugPrint(message)),
            );

  Future<void> init({
    required Future<SCREEN_ID> Function() initAndGetFirstScreen,
    LogNavigation? logNavigation,
  }) async {
    _rubigoStackManager.addListener(notifyListeners);
    _rubigoStackManager.addListener(() {
      _screenStackNotifier.value =
          _rubigoStackManager.screens.toListOfScreenId();
    });
    final firstScreen = await initAndGetFirstScreen();
    for (final screenSet in availableScreens) {
      //Wire up the rubigoRouter in each controller
      final controller = screenSet.getController;
      controller().rubigoRouter = this;
      //Wire up the controller in each screenWidget that has the RubigoControllerMixin
      final screenWidget = screenSet.screenWidget;
      if (screenWidget is RubigoScreenMixin) {
        (screenWidget as RubigoScreenMixin).controller =
            screenSet.getController();
      }
    }
    await _rubigoStackManager.replaceStack([firstScreen]);
  }

  final LogNavigation _logNavigation;
  final ListOfRubigoScreens<SCREEN_ID> availableScreens;
  final SCREEN_ID splashScreenId;
  final RubigoBusyService rubigoBusy;
  final RubigoStackManagerType<SCREEN_ID> _rubigoStackManager;

  final _navigatorKey = GlobalKey<NavigatorState>();

  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

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

  //region screenStackNotifier
  late final _screenStackNotifier = ValueNotifier<List<SCREEN_ID>>(
    _rubigoStackManager.screens.toListOfScreenId(),
  );

  ValueNotifier<List<SCREEN_ID>> get screenStackNotifier =>
      _screenStackNotifier;

  List<SCREEN_ID> get screenStack => _screenStackNotifier.value;

  //endregion

  @override
  Future<void> pop({bool ignoreWhenBusy = false}) async {
    if (_canNavigate(ignoreWhenBusy: ignoreWhenBusy)) {
      await rubigoBusy.busyWrapper(_rubigoStackManager.pop);
    }
  }

  @override
  Future<void> popTo(SCREEN_ID screenId, {bool ignoreWhenBusy = false}) async {
    if (_canNavigate(ignoreWhenBusy: ignoreWhenBusy)) {
      await rubigoBusy.busyWrapper(() => _rubigoStackManager.popTo(screenId));
    }
  }

  @override
  Future<void> push(SCREEN_ID screenId, {bool ignoreWhenBusy = false}) async {
    if (_canNavigate(ignoreWhenBusy: ignoreWhenBusy)) {
      await rubigoBusy.busyWrapper(() => _rubigoStackManager.push(screenId));
    }
  }

  @override
  Future<void> replaceStack(
    List<SCREEN_ID> screens, {
    bool ignoreWhenBusy = false,
  }) async {
    if (_canNavigate(ignoreWhenBusy: ignoreWhenBusy)) {
      await rubigoBusy
          .busyWrapper(() => _rubigoStackManager.replaceStack(screens));
    }
  }

  @override
  void remove(SCREEN_ID screenId, {bool ignoreWhenBusy = false}) {
    if (_canNavigate(ignoreWhenBusy: ignoreWhenBusy)) {
      _rubigoStackManager.remove(screenId);
    }
  }

  //region Flutter events onDidRemovePage and onPopPage
  Future<void> onDidRemovePage(Page<Object?> page) async {
    if (!_canNavigate(ignoreWhenBusy: true)) {
      // Notify Flutter about the current page stack, this might result in two
      // animations (pop/push), but there is nothing we can do here because we
      // are informed when the stack has already changed by the user. For
      // example, on iOS with a swipe back gesture. This can be prevented in
      // several ways:
      // 1. Use a PopScope widget with 'canPop is false', or equal to !isBusy
      // 2. Use the RubigoBusyService and widget, which blocks user interaction.
      // 3. Use the ignoreWhenBusy parameter with [push/pop/popTo/replaceStack]
      // when the interaction is started by the user.
      notifyListeners();
      return;
    }
    final pageKey = page.key;
    if (pageKey == null || pageKey is! ValueKey<SCREEN_ID>) {
      throw UnsupportedError(
        'PANIC: page.key must be of type ValueKey<$SCREEN_ID>.',
      );
    }
    final removedScreenId = pageKey.value;
    unawaited(
      _logNavigation(
        'onDidRemovePage(${removedScreenId.name}) called by Flutter framework.',
      ),
    );
    final lastScreenId = screenStack.last;
    if (removedScreenId != lastScreenId) {
      unawaited(_logNavigation('but ignored by us.'));
      //onDidRemovePage was initiated by the business logic.
      //In this case the screenStack is already valid
    } else {
      //onDidRemovePage was initiated by the backButton/predictiveBackGesture (Android) or swipeBack (iOS).
      //In this case we still need to adjust the screenStack accordingly
      unawaited(_logNavigation('and redirected to pop().'));
      await pop();
    }
  }

  bool onPopPage(Route<dynamic> route, dynamic result) {
    unawaited(_logNavigation('onPopPage() called by Flutter framework.'));
    if (_canNavigate(ignoreWhenBusy: true)) {
      unawaited(pop());
    } else {
      unawaited(_logNavigation('but rubigoRouter was busy navigating.'));
    }
    return false;
  }

  //endregion

  bool _canNavigate({required bool ignoreWhenBusy}) {
    if (!ignoreWhenBusy) {
      return true;
    }
    return !rubigoBusy.isBusy;
  }
}
