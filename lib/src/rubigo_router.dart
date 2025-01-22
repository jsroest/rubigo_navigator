import 'dart:async';

import 'package:flutter/foundation.dart';
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
    //Listen to updates and notify our listener, the RouterDelegate
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

  /// Specify the delay to be taken into consideration when a screen is popped
  /// from the stack by:
  /// 1. AppBars back button.
  /// 2. Android hardware back key.
  /// 3. Back gesture on iOS.
  /// 4. Predictive back gesture on Android.
  /// Because the back animation starts directly in case of 1 and 2, we can
  /// specify a delay here to minimize the ugliness in case we prevent the pop
  /// in mayPop. This can happen if we don't preemptively disable back
  /// navigation with a [PopScope] widget, because we have to check it at the
  /// time of pressing the back button.
  Duration onDidRemovePageDelay = const Duration(milliseconds: 300);

  /// This method must be passed to the [Navigator.onDidRemovePage] property.
  Future<void> onDidRemovePage(Page<Object?> page) async {
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
      return;
    }
    // onDidRemovePage was (probably) initiated by the backButton or
    // predictiveBackGesture (Android) or swipeBack (iOS).
    await _handleOnDidRemovePage(removedScreenId);
  }

  List<SCREEN_ID> get _getScreenStack =>
      _rubigoStackManager.screens.value.toListOfScreenId();

  Future<void> _handleOnDidRemovePage(SCREEN_ID screenId) async {
    // First, take notice if the app is busy while this function was called.
    final isBusy = busyService.isBusy;
    // Second, set isBusy to  true.
    await busyService.busyWrapper(
      () async {
        final stopWatch = Stopwatch()..start();
        // We have to ask the page if we may pop.
        var mayPop = true;
        // Get a copy of the current screen stack.
        final screenStackBefore = _getScreenStack;
        // Only perform a call to the controllers mayPop if the app is not busy.
        if (!isBusy) {
          // Find the controller
          final controller = availableScreens.find(screenId).getController();
          if (controller is RubigoControllerMixin<SCREEN_ID>) {
            // If the controller implements RubigoControllerMixin, call mayPop.
            unawaited(_logNavigation('Call mayPop().'));
            mayPop = await controller.mayPop();
            unawaited(_logNavigation('The controller returned "$mayPop"'));
          } else {
            // Otherwise the screen may always be popped
            unawaited(
              _logNavigation('The controller is not a RubigoControllerMixin, '
                  'mayPop is always "true"'),
            );
          }
          if (mayPop) {
            // Call pop to start navigating and await until it's done. Do not
            // notifyListeners as we might want to add a delay later.
            await _pop(notifyListeners: false);
          }
        }
        // Get a copy of the screenStack after handing pop, notice that it does
        // not have to be 'screenStackBefore' without the last screen. The
        // controllers can alter the screen stack in their onTop event.
        final screenStackAfter = _getScreenStack;
        final expectedScreenStack = [...screenStackBefore]..removeLast();
        if (!listEquals(expectedScreenStack, screenStackAfter)) {
          // In case of a back button press, the animation starts immediately.
          // If we notify Flutter's Navigator immediately about the new stack,
          // this results in an ugly animation, where back and forth are kind of
          // mixed up. Therefore we wait a bit to give the back animation
          // more time, before we start another one.
          stopWatch.stop();
          final minimumDelay = onDidRemovePageDelay;
          final durationTakenSoFar =
              Duration(milliseconds: stopWatch.elapsedMilliseconds);
          final remainingDelay = minimumDelay - durationTakenSoFar;
          if (!remainingDelay.isNegative) {
            debugPrint('remainingDelay: $remainingDelay');
            await Future<void>.delayed(remainingDelay);
          }
        }
        // Always call notifyListeners, as we can not risk that our screen stack
        // and flutters screen stack are not in sync.
        _rubigoStackManager.updateScreens();
      },
    );
  }

//endregion

  //region Navigation functions
  /// Pops the current screen from the stack
  /// If you wire this directly to a onButtonPressed event, you might want to
  /// set [ignoreWhenBusy] to true, to ignore events when the router is busy.
  Future<void> pop({bool ignoreWhenBusy = false}) =>
      _pop(ignoreWhenBusy: ignoreWhenBusy);

  Future<void> _pop({
    bool ignoreWhenBusy = false,
    bool notifyListeners = true,
  }) async {
    if (_canNavigate(ignoreWhenBusy: ignoreWhenBusy)) {
      unawaited(_logNavigation('pop() called.'));
      await busyService.busyWrapper(
        () => _rubigoStackManager.pop(notifyListeners: notifyListeners),
      );
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
