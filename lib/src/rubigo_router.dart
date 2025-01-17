import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:rubigo_router/rubigo_router.dart';
import 'package:rubigo_router/src/stack_manager/rubigo_stack_manager.dart';

/// A router based on [RubigoScreen]'s.
/// * Use the init function to initialize your app. When the initialization is
/// done, you must return the first screen of the app.
/// * During the initialisation the screen passed to splashScreenId is shown.
/// * Use [RubigoRouter.push], [RubigoRouter.pop], [RubigoRouter.popTo],
/// [RubigoRouter.replaceStack] and [RubigoRouter.remove] to alter the stack in
/// any way you like.
/// * You can use the [RubigoBusyService] to handle situations where the app is
/// busy and not ready for user actions/input. During navigation, the
/// [RubigoRouter] automatically sets [RubigoBusyService.isBusy] to true.
class RubigoRouter<SCREEN_ID extends Enum> with ChangeNotifier {
  /// Creates a RubigoRouter
  RubigoRouter({
    required this.availableScreens,
    required this.splashScreenId,
    RubigoBusyService? rubigoBusyService,
    LogNavigation? logNavigation,
    RubigoStackManager<SCREEN_ID>? rubigoStackManager,
    // If busyService was not given, create one ourselves.
  })  : busyService = rubigoBusyService ?? RubigoBusyService(),
        // If a logNavigation function was not given, create one ourselves.
        logNavigation = logNavigation ?? _defaultLogNavigation,
        // If a rubigoStackManager was not given, create one ourselves.
        _rubigoStackManager = rubigoStackManager ??
            RubigoStackManager(
              [availableScreens.find(splashScreenId)],
              availableScreens,
              logNavigation ?? _defaultLogNavigation,
            ) {
    //listen to changes on screens and notify our listeners
    _rubigoStackManager.screens.addListener(notifyListeners);
  }

  /// Call init to initialise the [RubigoRouter].
  /// Pass a function that handles your app initialisation first (like setting
  /// up your app with dependency-injection). When finished initialising, return
  /// the screen to start the app with.
  Future<void> init({
    required Future<SCREEN_ID> Function() initAndGetFirstScreen,
    LogNavigation? logNavigation,
  }) async {
    final firstScreen = await initAndGetFirstScreen();
    for (final screenSet in availableScreens) {
      // Wire up the rubigoRouter in each controller, if it is a
      // RubigoControllerMixin
      final controller = screenSet.getController();
      if (controller is RubigoControllerMixin<SCREEN_ID>) {
        controller.rubigoRouter = this;
      }
      // Wire up the controller in each screenWidget that is a RubigoScreenMixin
      if (screenSet.screenWidget is RubigoScreenMixin &&
          controller is RubigoControllerMixin<SCREEN_ID>) {
        final screenWidget = screenSet.screenWidget as RubigoScreenMixin;
        screenWidget.controller = controller;
      }
    }
    await replaceStack([firstScreen]);
  }

  /// This parameter contains all screens that are available for this router.
  final ListOfRubigoScreens<SCREEN_ID> availableScreens;

  /// This parameter contains the [SCREEN_ID] for the screen to use as splash
  /// screen.
  final SCREEN_ID splashScreenId;

  /// This parameter contains the busy service you want to use. If none is
  /// specified it will default to an instance of [RubigoBusyService].
  final RubigoBusyService busyService;

  /// Log the behavior of the [RubigoRouter] and companions.
  final LogNavigation logNavigation;

  //region Private
  bool _canNavigate({required bool ignoreWhenBusy}) {
    if (!ignoreWhenBusy) {
      return true;
    }
    return !busyService.isBusy;
  }

  final RubigoStackManager<SCREEN_ID> _rubigoStackManager;

  final _navigatorKey = GlobalKey<NavigatorState>();

  //endregion

  //region Properties to pass to Flutter's Navigator
  /// This is the navigator key that must be passed to Flutter's [Navigator].
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  /// This is the getter used by the [Navigator.pages] property.
  /// When this object calls [notifyListeners], the [Navigator] rebuilds and
  /// gets a fresh list of pages from this router.
  ValueNotifier<ListOfRubigoScreens<SCREEN_ID>> get screens =>
      _rubigoStackManager.screens;

  //endregion

  //region Navigation functions
  /// Pops the current screen from the stack
  /// If you wire this directly to a onButtonPressed event, you might want to
  /// set [ignoreWhenBusy] to true, to ignore events when the router is busy.
  Future<void> pop({bool ignoreWhenBusy = false}) async {
    if (_canNavigate(ignoreWhenBusy: ignoreWhenBusy)) {
      unawaited(logNavigation('pop() called.'));
      await busyService.busyWrapper(_rubigoStackManager.pop);
    }
  }

  /// Pop directly to the screen with [screenId].
  /// If you wire this directly to a onButtonPressed event, you might want to
  /// set [ignoreWhenBusy] to true, to ignore events when the router is busy.
  Future<void> popTo(SCREEN_ID screenId, {bool ignoreWhenBusy = false}) async {
    if (_canNavigate(ignoreWhenBusy: ignoreWhenBusy)) {
      unawaited(logNavigation('popTo(${screenId.name}) called.'));
      await busyService.busyWrapper(() => _rubigoStackManager.popTo(screenId));
    }
  }

  /// Push screen with [screenId] on the stack.
  /// If you wire this directly to a onButtonPressed event, you might want to
  /// set [ignoreWhenBusy] to true, to ignore events when the router is busy.
  Future<void> push(SCREEN_ID screenId, {bool ignoreWhenBusy = false}) async {
    if (_canNavigate(ignoreWhenBusy: ignoreWhenBusy)) {
      unawaited(logNavigation('push(${screenId.name}) called.'));
      await busyService.busyWrapper(() => _rubigoStackManager.push(screenId));
    }
  }

  /// Replace the current screen stack with [screens].
  /// If you wire this directly to a onButtonPressed event, you might want to
  /// set [ignoreWhenBusy] to true, to ignore events when the router is busy.
  Future<void> replaceStack(
    List<SCREEN_ID> screens, {
    bool ignoreWhenBusy = false,
  }) async {
    if (_canNavigate(ignoreWhenBusy: ignoreWhenBusy)) {
      unawaited(
        logNavigation(
          'replaceStack(${screens.map((e) => e.name).join('→')}) called.',
        ),
      );
      await busyService
          .busyWrapper(() => _rubigoStackManager.replaceStack(screens));
    }
  }

  /// Remove the screen with [screenId] silently from the stack.
  /// It is not likely that you wire this directly to a onButtonPressed event
  /// but if you want this call to be ignored when the router is busy, you can
  /// set [ignoreWhenBusy] to true.
  void remove(SCREEN_ID screenId, {bool ignoreWhenBusy = false}) {
    if (_canNavigate(ignoreWhenBusy: ignoreWhenBusy)) {
      unawaited(
        logNavigation('remove(${screenId.name}) called.'),
      );
      _rubigoStackManager.remove(screenId);
    }
  }

//endregion
}

Future<void> _defaultLogNavigation(String message) async => debugPrint(message);
