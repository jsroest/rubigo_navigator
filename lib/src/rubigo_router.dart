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
/// automatically marked busy.
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
        _logNavigation = logNavigation ?? _defaultLogNavigation,
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

  //region Private
  final LogNavigation _logNavigation;

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

  /// This method must be passed to the [Navigator.onDidRemovePage] property.
  /// Use this method or [onPopPage], not both.
  Future<void> onDidRemovePage(Page<Object?> page) async {
    if (busyService.isBusy) {
      // We can not navigate, because we are busy.
      // We have to inform Flutter that the change did not make it. This might
      // result in two animations (pop/push), but there is nothing we can do
      // here because we are informed that the stack has already changed by the
      // user, for example, on iOS with a swipe back gesture. This can be
      // prevented in several ways, but only in advance and never asynchronous:
      // 1. Use a PopScope widget with 'canPop is false', or equal to !isBusy
      // 2. Use the RubigoBusyService and widget, which blocks user interaction.
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
    final lastScreenId = _rubigoStackManager.screens.value.last.screenId;
    if (removedScreenId != lastScreenId) {
      // With this new event, we also receive this event when pages are removed
      // programmatically from the stack. Here onDidRemovePage was (probably)
      // initiated by the business logic, as the last page on the stack is not
      // the one that got removed. In this case the screenStack is already
      // valid.
      unawaited(
        _logNavigation(
          'The last page on the stack is ${lastScreenId.name}, therefore '
          'we are ignoring this call.',
        ),
      );
    } else {
      // onDidRemovePage was (probably) initiated by the backButton or
      // predictiveBackGesture (Android) or swipeBack (iOS).
      await _handlePop(removedScreenId);
      // Call notify listeners, because if the stack did not change in the pop()
      // call, which can happen Flutter thinks the top page has popped and we
      // are not in sync.
      notifyListeners();
    }
  }

  //ignore: deprecated_member_use
  /// This method must be passed to the [Navigator.onPopPage] property.
  /// Use this method or [onDidRemovePage], not both.
  bool onPopPage(Route<dynamic> _, dynamic __) {
    unawaited(_logNavigation('onPopPage() called by Flutter framework.'));
    if (busyService.isBusy) {
      unawaited(_logNavigation('but rubigoRouter was busy navigating.'));
    } else {
      unawaited(_handlePop(_rubigoStackManager.screens.value.last.screenId));
    }
    // Always return false and handle the pop() ourselves.
    return false;
  }

  Future<void> _handlePop(SCREEN_ID screenId) async {
    await busyService.busyWrapper(
      () async {
        final controller = availableScreens.find(screenId).getController();
        bool mayPop;
        if (controller is RubigoControllerMixin<SCREEN_ID>) {
          unawaited(_logNavigation('Call mayPop().'));
          mayPop = await controller.mayPop();
          unawaited(_logNavigation('The controller returned "$mayPop"'));
        } else {
          mayPop = true;
          unawaited(
            _logNavigation('The controller is not a RubigoControllerMixin, '
                'mayPop is always "true"'),
          );
        }
        if (mayPop) {
          await pop();
        }
      },
    );
  }

  //endregion

  //region Navigation functions
  /// Pops the current screen from the stack
  /// If you wire this directly to a onButtonPressed event, you might want to
  /// set [ignoreWhenBusy] to true, to ignore events when the router is busy.
  Future<void> pop({bool ignoreWhenBusy = false}) async {
    if (_canNavigate(ignoreWhenBusy: ignoreWhenBusy)) {
      unawaited(_logNavigation('pop() called.'));
      await busyService.busyWrapper(_rubigoStackManager.pop);
    }
  }

  /// Pop directly to the screen with [screenId].
  /// If you wire this directly to a onButtonPressed event, you might want to
  /// set [ignoreWhenBusy] to true, to ignore events when the router is busy.
  Future<void> popTo(SCREEN_ID screenId, {bool ignoreWhenBusy = false}) async {
    if (_canNavigate(ignoreWhenBusy: ignoreWhenBusy)) {
      unawaited(_logNavigation('popTo(${screenId.name}) called.'));
      await busyService.busyWrapper(() => _rubigoStackManager.popTo(screenId));
    }
  }

  /// Push screen with [screenId] on the stack.
  /// If you wire this directly to a onButtonPressed event, you might want to
  /// set [ignoreWhenBusy] to true, to ignore events when the router is busy.
  Future<void> push(SCREEN_ID screenId, {bool ignoreWhenBusy = false}) async {
    if (_canNavigate(ignoreWhenBusy: ignoreWhenBusy)) {
      unawaited(_logNavigation('push(${screenId.name}) called.'));
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
        _logNavigation(
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
        _logNavigation('remove(${screenId.name}) called.'),
      );
      _rubigoStackManager.remove(screenId);
    }
  }

//endregion
}

Future<void> _defaultLogNavigation(String message) async => debugPrint(message);
