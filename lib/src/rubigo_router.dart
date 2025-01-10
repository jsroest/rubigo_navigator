import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:rubigo_navigator/src/extensions/extensions.dart';
import 'package:rubigo_navigator/src/flutter/busy/rubigo_busy_service.dart';
import 'package:rubigo_navigator/src/mixins/rubigo_screen_mixin.dart';
import 'package:rubigo_navigator/src/rubigo_screen.dart';
import 'package:rubigo_navigator/src/stack_manager/rubigo_stack_manager.dart';
import 'package:rubigo_navigator/src/types/rubigo_type_definitions.dart';

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
  })  : busyService = rubigoBusyService ?? RubigoBusyService(),
        _logNavigation =
            logNavigation ?? ((message) async => debugPrint(message)),
        _rubigoStackManager = rubigoStackManager ??
            RubigoStackManager(
              [availableScreens.find(splashScreenId)],
              availableScreens,
            );

  /// Call init to initialise the [RubigoRouter].
  /// Pass a function that handles your app initialisation first (like setting
  /// up your app with dependency-injection). When finished initialising, return
  /// the screen to start the app with.
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
  /// When this object calls [notifyListeners], the [Navigator] rebuilds and gets
  /// a fresh list of pages from this router.
  List<RubigoScreen<SCREEN_ID>> get screens {
    final result = _rubigoStackManager.screens;
    unawaited(
      _logNavigation.call(
        'Screen stack: ${_screenStackNotifier.value.breadCrumbs()}.',
      ),
    );
    return result;
  }

  /// This method must be passed to the [Navigator.onDidRemovePage] property.
  /// Use this method or [onDidRemovePage], not both.
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

  //ignore: deprecated_member_use
  /// This method must be passed to the [Navigator.onPopPage] property.
  /// Use this method or [onDidRemovePage], not both.
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

  //region ScreenStackNotifier
  late final _screenStackNotifier = ValueNotifier<List<SCREEN_ID>>(
    _rubigoStackManager.screens.toListOfScreenId(),
  );

  /// If your app wants to react on screen stack changes, you can listen to this
  /// notifier. Don't use [RubigoRouter.screens] for this, as this will result
  /// in multiple rows in the logging.
  ValueNotifier<List<SCREEN_ID>> get screenStackNotifier =>
      _screenStackNotifier;

  /// Use this if you want to get the latest stable screen stack.
  List<SCREEN_ID> get screenStack => _screenStackNotifier.value;

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
