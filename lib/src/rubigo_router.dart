import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:rubigo_router/rubigo_router.dart';
import 'package:rubigo_router/src/stack_manager/last_page_popped_exception.dart';
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
    // handle the back event.
    await ui.handleBackEvent();
  }

//endregion

// region Programmatic navigation functions
  /// Pops the current screen from the stack

  Future<void> pop() => _pop(notifyListeners: true);

  Future<void> _pop({required bool notifyListeners}) async {
    unawaited(_logNavigation('pop() called.'));
    try {
      await busyService.busyWrapper(
        () => _rubigoStackManager.pop(notifyListeners: notifyListeners),
      );
    } on LastPagePoppedException catch (e) {
      unawaited(_logNavigation(e.message));
      unawaited(_logNavigation('The app is closed.'));
      unawaited(SystemNavigator.pop());
    }
  }

  /// Pop directly to the screen with [screenId].
  Future<void> popTo(SCREEN_ID screenId) async {
    unawaited(_logNavigation('popTo(${screenId.name}) called.'));
    await busyService.busyWrapper(() => _rubigoStackManager.popTo(screenId));
  }

  /// Push screen with [screenId] on the stack.
  Future<void> push(SCREEN_ID screenId) async {
    unawaited(_logNavigation('push(${screenId.name}) called.'));
    await busyService.busyWrapper(() => _rubigoStackManager.push(screenId));
  }

  /// Replace the current screen stack with [screens].
  Future<void> replaceStack(List<SCREEN_ID> screens) async {
    unawaited(
      _logNavigation(
        'replaceStack(${screens.map((e) => e.name).join('→')}) called.',
      ),
    );
    await busyService
        .busyWrapper(() => _rubigoStackManager.replaceStack(screens));
  }

  /// Remove the screen with [screenId] silently from the stack.
  void remove(SCREEN_ID screenId) {
    unawaited(
      _logNavigation('remove(${screenId.name}) called.'),
    );
    _rubigoStackManager.remove(screenId);
  }

//endregion

//region User Initiated (UI) navigation functions
  /// Use these navigation functions everywhere the origin is user initiated.
  /// these calls will be ignored automatically if the app is busy.
  late final Ui<SCREEN_ID> ui = Ui<SCREEN_ID>(
    pop: () async {
      if (busyService.isBusy) {
        unawaited(
          _logNavigation('Pop was called by the user, but we are busy'),
        );
        return;
      }
      await _pop(notifyListeners: true);
    },
    popTo: (SCREEN_ID screenId) async {
      if (busyService.isBusy) {
        unawaited(
          _logNavigation('PopTo(${screenId.name}) was called by the user, '
              'but we are busy'),
        );
        return;
      }
      await popTo(screenId);
    },
    push: (SCREEN_ID screenId) async {
      if (busyService.isBusy) {
        unawaited(
          _logNavigation('Push(${screenId.name}) was called by the user, '
              'but we are busy'),
        );
        return;
      }
      await push(screenId);
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
      await replaceStack(screens);
    },
    remove: (SCREEN_ID screenId) {
      if (busyService.isBusy) {
        unawaited(
          _logNavigation('remove(${screenId.name}) was called by the user, '
              'but we are busy'),
        );
        return;
      }
      remove(screenId);
    },
    handleBackEvent: () async {
      // Get the page to pop from the stack.
      final screenId = _rubigoStackManager.screens.value.last.screenId;
      // First, take notice if the app is busy while this function was called.
      final isBusy = busyService.isBusy;
      // Second, set isBusy to  true.
      await busyService.busyWrapper(
        () async {
          // We have to ask the page if we may pop.
          var mayPop = true;
          // Only perform a call to the controllers mayPop if the app is not
          // busy.
          if (!isBusy) {
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
              unawaited(
                _logNavigation('The controller is not a RubigoControllerMixin, '
                    'mayPop is always "true"'),
              );
            }
            if (mayPop) {
              // Call pop to start navigating and await until it's done. Do not
              // notifyListeners, we will do that here below.
              await _pop(notifyListeners: false);
            }
          }
          // Always call notifyListeners, as we can not risk that our screen
          // stack and flutters screen stack are not in sync.
          _rubigoStackManager.updateScreens();
        },
      );
    },
  );

//endregion
}

/// This class groups al navigation functions, that are intended to be called
/// on a user action. Each function will be ignored if the app is busy.
class Ui<SCREEN_ID extends Enum> {
  /// Creates a Ui class
  Ui({
    required this.pop,
    required this.popTo,
    required this.push,
    required this.replaceStack,
    required this.remove,
    required this.handleBackEvent,
  });

  /// Use this function when the pop is user initiated.
  final Future<void> Function() pop;

  /// Use this function when the popTo is user initiated.
  final Future<void> Function(SCREEN_ID screenId) popTo;

  /// Use this function when the push is user initiated.
  final Future<void> Function(SCREEN_ID screenId) push;

  /// Use this function when the replaceStack is user initiated.
  final Future<void> Function(List<SCREEN_ID> screens) replaceStack;

  /// Use this function when the remove is user initiated.
  final void Function(SCREEN_ID screenId) remove;

  /// Use this function when the handleBackEvent is user initiated.
  final Future<void> Function() handleBackEvent;
}

Future<void> _defaultLogNavigation(String message) async => debugPrint(message);
