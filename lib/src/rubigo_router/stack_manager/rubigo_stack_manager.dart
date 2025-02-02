import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:rubigo_router/rubigo_router.dart';
import 'package:rubigo_router/src/rubigo_router/stack_manager/last_page_popped_exception.dart';
import 'package:rubigo_router/src/rubigo_router/stack_manager/navigation_events.dart';

/// This manages the screen stack. It provides functions to manipulate the stack
/// and it fires events like [RubigoControllerMixin.onTop] and
/// [RubigoControllerMixin.willShow]
class RubigoStackManager<SCREEN_ID extends Enum> {
  /// Creates a RubigoStackManager
  RubigoStackManager(
    this.screenStack,
    this._availableScreens,
    this._logNavigation,
  ) : screens = ValueNotifier<List<RubigoScreen<SCREEN_ID>>>([...screenStack]);

  /// This is the actual screen stack, which can have other contents than
  /// 'screens' when the app is busy navigating and the stack is not stable yet.
  ListOfRubigoScreens<SCREEN_ID> screenStack;

  // This is a list of all available screens.
  final ListOfRubigoScreens<SCREEN_ID> _availableScreens;

  // This function is called for logging purposes.
  final LogNavigation _logNavigation;

  /// The current stable version of the screen stack. It is only updated
  /// when navigation is complete.
  final ValueNotifier<ListOfRubigoScreens<SCREEN_ID>> screens;

  /// Pops a screen from the stack. This call can generate more navigation
  /// calls.
  Future<void> pop() => _navigate(Pop<SCREEN_ID>());

  /// Pop directly to a specific screen on the stack. This call can generate
  /// more navigation calls.
  Future<void> popTo(SCREEN_ID screenId) => _navigate(PopTo(screenId));

  /// Push a specific screen on the stack. This call can generate more
  /// navigation calls.
  Future<void> push(SCREEN_ID screenId) => _navigate(Push(screenId));

  /// Replace the stack with a new list of screens. This call can generate more
  /// navigation calls.
  Future<void> replaceStack(List<SCREEN_ID> screens) =>
      _navigate(ReplaceStack(screens));

  /// Remove a screen silently from the stack. This call can not generate more
  /// navigation calls, because it does not fire any events.
  Future<void> remove(SCREEN_ID screenId) => _navigate(Remove(screenId));

  //region _navigate
  bool _inWillShow = false;
  bool _inRemovedFromStack = false;
  int _eventCounter = 0;

  RubigoChangeInfo<SCREEN_ID>? _changeInfo;

  Future<void> _navigate(NavigationEvent<SCREEN_ID> navigationEvent) async {
    if (_eventCounter == 0) {
      _changeInfo = null;
    }
    if (_inWillShow) {
      const txt = 'Developer: you may not call push, pop, popTo, replaceStack '
          'or remove in the willShow method.';
      await _logNavigation(txt);
      throw UnsupportedError(txt);
    }
    if (_inRemovedFromStack) {
      const txt = 'Developer: you may not call push, pop, popTo, replaceStack '
          'or remove in the removedFromStack method.';
      await _logNavigation(txt);
      throw UnsupportedError(txt);
    }
    switch (navigationEvent) {
      case Push<SCREEN_ID>():
        _changeInfo = await _push(navigationEvent);
      case Pop():
        _changeInfo = await _pop();
      case PopTo<SCREEN_ID>():
        _changeInfo = await _popTo(navigationEvent);
      case ReplaceStack<SCREEN_ID>():
        _changeInfo = await _replaceStack(navigationEvent);
      case Remove<SCREEN_ID>():
        await _remove(navigationEvent);
    }

    if (_eventCounter == 0) {
      // When the eventCounter is 0, we know that no navigation functions have
      // been called in the last onTop event.
      final tmpChangeInfo = _changeInfo;
      if (tmpChangeInfo != null) {
        final controller = screenStack.last.getController();
        if (controller is RubigoControllerMixin) {
          _inWillShow = true;
          await controller.willShow(tmpChangeInfo);
          _inWillShow = false;
        }
      }
      await updateScreens();
    }
  }

  Future<RubigoChangeInfo<SCREEN_ID>> _push(
    Push<SCREEN_ID> navigationEvent,
  ) async {
    final previousScreen = screenStack.last;
    final newScreen = _availableScreens.find(navigationEvent.screenId);
    screenStack.add(newScreen);
    final controller = newScreen.getController();
    final changeInfo = RubigoChangeInfo<SCREEN_ID>(
      EventType.push,
      previousScreen.screenId,
      screenStack.toListOfScreenId(),
    );
    if (controller is RubigoControllerMixin) {
      _eventCounter++;
      await controller.onTop(changeInfo);
      _eventCounter--;
    }
    return changeInfo;
  }

  Future<RubigoChangeInfo<SCREEN_ID>> _pop() async {
    if (screenStack.length < 2) {
      throw LastPagePoppedException('The last page is popped.');
    }
    final previousScreen = screenStack.last;
    screenStack.removeLast();
    final newScreen = screenStack.last;
    final controller = newScreen.getController();
    final changeInfo = RubigoChangeInfo(
      EventType.pop,
      previousScreen.screenId,
      screenStack.toListOfScreenId(),
    );
    if (controller is RubigoControllerMixin) {
      _eventCounter++;
      await controller.onTop(changeInfo);
      _eventCounter--;
    }
    return changeInfo;
  }

  Future<RubigoChangeInfo<SCREEN_ID>> _popTo(
    PopTo<SCREEN_ID> navigationEvent,
  ) async {
    final previousScreen = screenStack.last;
    final index = screenStack.indexWhere(
      (e) => e.screenId == navigationEvent.screenId,
    );
    // If not found, or the topmost one
    if (index == -1 || index == screenStack.length - 1) {
      final txt = 'Developer: With popTo, you tried to navigate to '
          '${navigationEvent.screenId.name}, which was not below this screen on '
          'the stack.';
      await _logNavigation(txt);
      throw UnsupportedError(txt);
    }
    screenStack.removeRange(index + 1, screenStack.length);

    final newScreen = screenStack.last;
    final controller = newScreen.getController();
    final changeInfo = RubigoChangeInfo(
      EventType.popTo,
      previousScreen.screenId,
      screenStack.toListOfScreenId(),
    );
    if (controller is RubigoControllerMixin) {
      _eventCounter++;
      await controller.onTop(changeInfo);
      _eventCounter--;
    }
    return changeInfo;
  }

  Future<RubigoChangeInfo<SCREEN_ID>> _replaceStack(
    ReplaceStack<SCREEN_ID> navigationEvent,
  ) async {
    final previousScreen = screenStack.last;
    screenStack = navigationEvent.screenStack.toListOfRubigoScreen(
      _availableScreens,
    );
    final controller = screenStack.last.getController();
    final changeInfo = RubigoChangeInfo(
      EventType.replaceStack,
      previousScreen.screenId,
      screenStack.toListOfScreenId(),
    );
    if (controller is RubigoControllerMixin) {
      _eventCounter++;
      await controller.onTop(changeInfo);
      _eventCounter--;
    }
    return changeInfo;
  }

  Future<void> _remove(
    Remove<SCREEN_ID> navigationEvent,
  ) async {
    final index = screenStack.indexWhere(
      (e) => e.screenId == navigationEvent.screenId,
    );
    if (index == -1) {
      final txt = 'Developer: You can only remove screens that exist on the '
          'stack (${navigationEvent.screenId.name} not found).';
      await _logNavigation(txt);
      throw UnsupportedError(txt);
    }
    screenStack.removeAt(index);
  }

  //endregion navigate

  /// Force Flutters [Navigator] to match our screen stack.
  Future<void> updateScreens() async {
    final oldScreenSet = screens.value.toSet();
    final newScreenSet = screenStack.toSet();
    // The ValueNotifier always calls it's listeners when we assign an new copy
    // of the stack. Also if the contents are logically the same. In this case
    // this is what we want, specifically in case of handling onDidRemovePage.
    screens.value = [...screenStack];
    await _logNavigation(
      'Screens: '
      '${screens.value.toListOfScreenId().map((e) => e.name).join('→')}.',
    );
    // Inform al controllers that were removed from the stack.
    for (final screen in oldScreenSet.difference(newScreenSet)) {
      final controller = screen.getController();
      if (controller is RubigoControllerMixin<SCREEN_ID>) {
        _inRemovedFromStack = true;
        await controller.removedFromStack();
        _inRemovedFromStack = false;
      }
    }
    for (final callBack in updateScreensCallBack) {
      callBack.call();
    }
  }

  /// Register a callback in this list, if you want to be notified if the
  /// updateScreens function is called.
  final updateScreensCallBack = <VoidCallback>[];
}
