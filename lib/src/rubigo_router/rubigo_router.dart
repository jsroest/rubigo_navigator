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
/// * Use the navigation functions in [RubigoRouter] when you want to
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
    await _logNavigation('RubigoRouter.init() called.');
    final firstScreen = await initAndGetFirstScreen();
    await _logNavigation(
      'RubigoRouter.init() ended. First screen will be ${firstScreen.name}.',
    );
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
  void onDidRemovePage(Page<Object?> page) {
    final pageKey = page.key;
    if (pageKey == null) {
      final txt =
          'PANIC: page.key must be of type ValueKey<$SCREEN_ID>, but found '
          'null.';
      unawaited(
        _logNavigation(txt).then(throw UnsupportedError(txt)),
      );
    }
    if (pageKey is! ValueKey<SCREEN_ID>) {
      final txt =
          'PANIC: page.key must be of type ValueKey<$SCREEN_ID>, but found '
          '${pageKey.runtimeType}.';
      unawaited(
        _logNavigation(txt).then(throw UnsupportedError(txt)),
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

    // Remove the last page, so the screens is the same as Flutter expects.
    // Just in case the widget tree rebuilds for some reason.
    // Note: this will not inform the listeners, this is intended behavior.
    screens.value.removeLast();

    Future<void> gestureCallback() async {
      final inProgress = navState.userGestureInProgress;
      if (!inProgress) {
        navState.userGestureInProgressNotifier.removeListener(gestureCallback);
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

    final warningText = '''
RubigoRouter warning.
"onDidRemovePage called" for ${removedScreenId.name}, but the source was not a userGesture. 
The cause is most likely that Navigator.maybePop(context) was (indirectly) called.
This can happen when:
- A regular BackButton was used to pop this page. Solution: Use a rubigoBackButton in the AppBar.
- The MaterialApp.backButtonDispatcher was not a RubigoRootBackButtonDispatcher.
- The pop was not caught by a RubigoBackGesture widget.
''';
    unawaited(_logNavigation(warningText));

    // This is a workaround for the following exception:
    // Unhandled Exception: 'package:flutter/src/widgets/navigator.dart': Failed assertion: line 4931 pos 12: '!_debugLocked': is not true.
    // Which can happen if a showDialog (or other pageless route) was pushed in
    // the mayPop callback. This is a workaround and should not end up in
    // production. Read the warning here above.
    Future.delayed(Duration.zero, callPop);
  }

  //endregion

  // region navigation functions
  /// Pops the current screen from the stack
  Future<void> pop() async {
    await _logNavigation('pop() called.');
    try {
      await busyService.busyWrapper(_rubigoStackManager.pop);
    } on LastPagePoppedException catch (e) {
      await _logNavigation(e.message);
      await _onLastPagePopped();
    }
  }

  /// Pop directly to the screen with [screenId].
  Future<void> popTo(SCREEN_ID screenId) async {
    await _logNavigation('popTo(${screenId.name}) called.');
    await busyService.busyWrapper(() => _rubigoStackManager.popTo(screenId));
  }

  /// Push screen with [screenId] on the stack.
  Future<void> push(SCREEN_ID screenId) async {
    await _logNavigation('push(${screenId.name}) called.');
    await busyService.busyWrapper(() => _rubigoStackManager.push(screenId));
  }

  /// Replace the current screen stack with \[screens\].
  Future<void> replaceStack(List<SCREEN_ID> screens) async {
    await _logNavigation(
      'replaceStack(${screens.map((e) => e.name).join('→')}) called.',
    );
    await busyService.busyWrapper(
      () => _rubigoStackManager.replaceStack(screens),
    );
  }

  /// Remove the screen with \[screenId\] silently from the stack.
  Future<void> remove(SCREEN_ID screenId) async {
    await _logNavigation('remove(${screenId.name}) called.');
    await _rubigoStackManager.remove(screenId);
  }

  // endregion

//region User initiated (ui) navigation functions
  /// {@template rubigoRouter.ui.pop}
  /// Use these navigation functions everywhere when origin is user initiated.
  /// these calls will be ignored automatically if the app is busy.
  /// {@endtemplate}
  late final Ui<SCREEN_ID> ui = Ui<SCREEN_ID>(
    pop: () async {
// First, take notice if the app is busy while this function was called.
      final isBusy = busyService.isBusy;
// Second, set isBusy to  true.
      await busyService.busyWrapper(
        () async {
          if (isBusy) {
            await _logNavigation(
              'Pop was called by the user, but the app is busy.',
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
            await _logNavigation('Call mayPop().');
            mayPop = await controller.mayPop();
            await _logNavigation('The controller returned "$mayPop"');
          } else {
// Otherwise the screen may always be popped
            mayPop = true;
            await _logNavigation(
                'The controller is not a RubigoControllerMixin, '
                'mayPop is always "true"');
          }
          if (mayPop) {
            await pop();
          }
        },
      );
    },
    popTo: (SCREEN_ID screenId) async {
      if (busyService.isBusy) {
        await _logNavigation('PopTo(${screenId.name}) was called by the user, '
            'but the app is busy.');
        return;
      }
      await popTo(screenId);
    },
    push: (SCREEN_ID screenId) async {
      if (busyService.isBusy) {
        await _logNavigation('Push(${screenId.name}) was called by the user, '
            'but the app is busy.');
        return;
      }
      await push(screenId);
    },
    replaceStack: (List<SCREEN_ID> screens) async {
      if (busyService.isBusy) {
        await _logNavigation(
            'replaceStack(${screens.breadCrumbs()}) was called by the user, '
            'but the app is busy.');
        return;
      }
      await replaceStack(screens);
    },
    remove: (SCREEN_ID screenId) async {
      if (busyService.isBusy) {
        await _logNavigation('remove(${screenId.name}) was called by the user, '
            'but the app is busy.');
        return;
      }
      await remove(screenId);
    },
  );
//endregion
}

/// This class groups navigation functions together.
/// A class is used for this, because dart lacks namespaces.
class Ui<SCREEN_ID extends Enum> {
  /// Creates a Ui class
  Ui({
    required this.pop,
    required this.popTo,
    required this.push,
    required this.replaceStack,
    required this.remove,
  });

  /// ui.pop()
  final Future<void> Function() pop;

  /// ui.popTo
  final Future<void> Function(SCREEN_ID screenId) popTo;

  /// ui.push
  final Future<void> Function(SCREEN_ID screenId) push;

  /// ui.replaceStack
  final Future<void> Function(List<SCREEN_ID> screens) replaceStack;

  /// ui.remove
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
