import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:rubigo_router/rubigo_router.dart';
import 'package:rubigo_router/src/rubigo_router/stack_manager/last_page_popped_exception.dart';
import 'package:rubigo_router/src/rubigo_router/stack_manager/rubigo_stack_manager.dart';

/// A router based on [RubigoScreen]'s.
/// * Use the init function to initialize your app. When the initialization is
/// done, you must return the first screen of the app.
/// * During the initialisation a splashscreen is shown.
/// * Use the navigation functions in [RubigoRouter.prog] when you want to
/// change the stack.
/// * Use the navigation functions in [RubigoRouter.ui] when you want to change
/// the stack, but the action is initiated by the user. The call is ignored
/// when the app is busy. See [RubigoBusyService].
/// * During navigation, the app is automatically marked as busy, but you can
/// set the app as busy by wrapping your code in
/// [RubigoBusyService.busyWrapper].
class RubigoRouter<SCREEN_ID extends Enum> with ChangeNotifier {
  /// Creates a RubigoRouter
  RubigoRouter({
    required this.availableScreens,
    required this.splashScreenId,
    RubigoBusyService? rubigoBusyService,
    LogNavigation? logNavigation,
    RubigoStackManager<SCREEN_ID>? rubigoStackManager,
    Future<void> Function()? onLastPagePopped,

    /// If busyService was not given, create one ourselves.
  })  : busyService = rubigoBusyService ?? RubigoBusyService(),

        /// If a logNavigation function was not given use a default
        /// implementation
        _logNavigation = logNavigation ?? _defaultLogNavigation,

        /// If a rubigoStackManager was not given, create one ourselves.
        _rubigoStackManager = rubigoStackManager ??
            RubigoStackManager(
              [availableScreens.find(splashScreenId)],
              availableScreens,
              logNavigation ?? _defaultLogNavigation,
            ),

        /// If a onLastPagePopped function was not given use a default
        /// implementation
        _onLastPagePopped = onLastPagePopped ?? _defaultOnLastPagePopped {
    ///Listen to updates and notify our listener, the RouterDelegate
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
    await prog.replaceStack([firstScreen]);
  }

  /// This parameter contains all screens that are available for this router.
  final ListOfRubigoScreens<SCREEN_ID> availableScreens;

  /// This parameter contains the [SCREEN_ID] for the screen to use as splash
  /// screen.
  final SCREEN_ID splashScreenId;

  /// This parameter contains the busy service you want to use. If none is
  /// specified it will default to an instance of [RubigoBusyService].
  final RubigoBusyService busyService;

  /// This function can be used to log all that is related to navigation
  LogNavigation get logNavigation => _logNavigation;

//region Private
  final LogNavigation _logNavigation;

  final RubigoStackManager<SCREEN_ID> _rubigoStackManager;

  final Future<void> Function() _onLastPagePopped;

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
  Future<void> onDidRemovePage(Page<Object?> page) async {
    final pageKey = page.key;
    if (pageKey == null || pageKey is! ValueKey<SCREEN_ID>) {
      throw UnsupportedError(
        'PANIC: page.key must be of type ValueKey<$SCREEN_ID>.',
      );
    }
    final removedScreenId = pageKey.value;
    final lastScreenId = _rubigoStackManager.screens.value.last.screenId;
    if (removedScreenId != lastScreenId) {
      // With this new event, we also receive this event when pages are removed
      // programmatically from the stack. Here onDidRemovePage was (probably)
      // initiated by the business logic, as the last page on the stack is not
      // the one that got removed. In this case the screenStack is already
      // valid.
      unawaited(
        _logNavigation(
          'onDidRemovePage(${removedScreenId.name}) called. Last page is '
          '${lastScreenId.name}, ignoring.',
        ),
      );
      return;
    }

    // handle the back event.
    unawaited(
      _logNavigation(
        'onDidRemovePage(${removedScreenId.name}) called.',
      ),
    );

    Future<void> callPop() async {
      // This function calls ui.pop and keeps track if updateScreens is being
      // called, while executing ui.pop().
      var updateScreensIsCalled = false;
      void updateScreenCallback() => updateScreensIsCalled = true;
      _rubigoStackManager.updateScreensCallBack.add(updateScreenCallback);
      await ui.pop();
      if (!updateScreensIsCalled) {
        await _rubigoStackManager.updateScreens();
      }
      _rubigoStackManager.updateScreensCallBack.remove(updateScreenCallback);
    }

    final navState = _navigatorKey.currentState;
    if (navState == null) {
      // We cannot continue if we cannot access Flutter's navigator.
      return;
    }

    Future<void> gestureCallback() async {
      final inProgress = navState.userGestureInProgress;
      if (!inProgress) {
        navState.userGestureInProgressNotifier.removeListener(gestureCallback);
        // Remove the last page, so the screens is the same as Flutter expects.
        // Just in case the widget tree rebuilds for some reason.
        screens.value = screens.value..removeLast();
        await callPop();
      }
    }

    if (navState.userGestureInProgress) {
      // We have to wait for the gesture to finish. Otherwise pageless routes,
      // that might have been added in mayPop (like showDialog), are popped
      // together with the page. That is how Navigator 2.0 works, nothing we
      // can about that. Wait for the gesture to complete and the perform the
      // pop().
      navState.userGestureInProgressNotifier.addListener(gestureCallback);
      return;
    }
    await callPop();
  }

//endregion

// region Program initiated (prog) navigation functions
  /// Use these navigation functions everywhere when origin is programmatic.
  /// these calls will not be ignored if the app is busy.
  late final NavigationFunctions<SCREEN_ID> prog =
      NavigationFunctions<SCREEN_ID>(
    /// Pops the current screen from the stack
    pop: () async {
      unawaited(_logNavigation('pop() called.'));
      try {
        await busyService.busyWrapper(_rubigoStackManager.pop);
      } on LastPagePoppedException catch (e) {
        await _logNavigation(e.message);
        await _logNavigation('The app is closed.');
        await _onLastPagePopped();
      }
    },

    /// Pop directly to the screen with [screenId].
    popTo: (SCREEN_ID screenId) async {
      unawaited(_logNavigation('popTo(${screenId.name}) called.'));
      await busyService.busyWrapper(() => _rubigoStackManager.popTo(screenId));
    },

    /// Push screen with [screenId] on the stack.
    push: (SCREEN_ID screenId) async {
      unawaited(_logNavigation('push(${screenId.name}) called.'));
      await busyService.busyWrapper(() => _rubigoStackManager.push(screenId));
    },

    /// Replace the current screen stack with [screens].
    replaceStack: (List<SCREEN_ID> screens) async {
      unawaited(
        _logNavigation(
          'replaceStack(${screens.map((e) => e.name).join('→')}) called.',
        ),
      );
      await busyService
          .busyWrapper(() => _rubigoStackManager.replaceStack(screens));
    },

    /// Remove the screen with [screenId] silently from the stack.
    remove: (SCREEN_ID screenId) async {
      unawaited(
        _logNavigation('remove(${screenId.name}) called.'),
      );
      await _rubigoStackManager.remove(screenId);
    },
  );

//endregion

//region User initiated (ui) navigation functions
  /// Use these navigation functions everywhere when origin is user initiated.
  /// these calls will be ignored automatically if the app is busy.
  late final NavigationFunctions<SCREEN_ID> ui = NavigationFunctions<SCREEN_ID>(
    pop: () async {
// First, take notice if the app is busy while this function was called.
      final isBusy = busyService.isBusy;
// Second, set isBusy to  true.
      await busyService.busyWrapper(
        () async {
          if (isBusy) {
            unawaited(
              _logNavigation('Pop was called by the user, but we are busy'),
            );
            return;
          }
// We have to ask the page if we may pop.
          final bool mayPop;
// Get the page to pop from the stack.
          final screenId = _rubigoStackManager.screenStack.last.screenId;
// Find the controller
          final controller = availableScreens.find(screenId).getController();
          if (controller is RubigoControllerMixin<SCREEN_ID>) {
// If the controller implements RubigoControllerMixin, call
// mayPop.
            unawaited(_logNavigation('Call mayPop().'));
            mayPop = await controller.mayPop();
            unawaited(_logNavigation('The controller returned "$mayPop"'));
          } else {
// Otherwise the screen may always be popped
            mayPop = true;
            unawaited(
              _logNavigation('The controller is not a RubigoControllerMixin, '
                  'mayPop is always "true"'),
            );
          }
          if (mayPop) {
            await prog.pop();
          }
        },
      );
    },
    popTo: (SCREEN_ID screenId) async {
      if (busyService.isBusy) {
        unawaited(
          _logNavigation('PopTo(${screenId.name}) was called by the user, '
              'but we are busy'),
        );
        return;
      }
      await prog.popTo(screenId);
    },
    push: (SCREEN_ID screenId) async {
      if (busyService.isBusy) {
        unawaited(
          _logNavigation('Push(${screenId.name}) was called by the user, '
              'but we are busy'),
        );
        return;
      }
      await prog.push(screenId);
    },
    replaceStack: (List<SCREEN_ID> screens) async {
      if (busyService.isBusy) {
        unawaited(
          _logNavigation(
              'replaceStack(${screens.breadCrumbs()}) was called by the user, '
              'but we are busy'),
        );
        return;
      }
      await prog.replaceStack(screens);
    },
    remove: (SCREEN_ID screenId) async {
      if (busyService.isBusy) {
        unawaited(
          _logNavigation('remove(${screenId.name}) was called by the user, '
              'but we are busy'),
        );
        return;
      }
      await prog.remove(screenId);
    },
  );
//endregion
}

/// This class groups navigation functions together, like for "ui" and "prog"
/// use. A class is used for this, because dart lacks namespaces.
class NavigationFunctions<SCREEN_ID extends Enum> {
  /// Creates a Ui class
  NavigationFunctions({
    required this.pop,
    required this.popTo,
    required this.push,
    required this.replaceStack,
    required this.remove,
  });

  /// Use this function when the pop is initiated by the user.
  final Future<void> Function() pop;

  /// Use this function when the popTo is initiated by the user.
  final Future<void> Function(SCREEN_ID screenId) popTo;

  /// Use this function when the push is initiated by the user.
  final Future<void> Function(SCREEN_ID screenId) push;

  /// Use this function when the replaceStack is initiated by the user.
  final Future<void> Function(List<SCREEN_ID> screens) replaceStack;

  /// Use this function when the remove is initiated by the user.
  final Future<void> Function(SCREEN_ID screenId) remove;
}

Future<void> _defaultLogNavigation(String message) async {
  if (kDebugMode) {
    debugPrint(message);
  }
}

Future<void> _defaultOnLastPagePopped() async {
  await SystemNavigator.pop();
}
