import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:rubigo_router/rubigo_router.dart';
import 'package:rubigo_router/src/stack_manager/navigation_events/navigation_events.dart';

/// This manages the screen stack. It provides functions to manipulate the stack
/// and it fires events like [RubigoControllerMixin.onTop] and
/// [RubigoControllerMixin.willShow]
class RubigoStackManager<SCREEN_ID extends Enum> {
  /// Creates a RubigoStackManager
  RubigoStackManager(
    this._screenStack,
    this._availableScreens,
    this._logNavigation,
  ) : screens = ValueNotifier<List<RubigoScreen<SCREEN_ID>>>([..._screenStack]);

  //This is the actual screen stack, which can be
  ListOfRubigoScreens<SCREEN_ID> _screenStack;

  //This is a list of all available screens
  final ListOfRubigoScreens<SCREEN_ID> _availableScreens;

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
  /// navigation calls.
  void remove(SCREEN_ID screenId) {
    final index = _screenStack.indexWhere((e) => e.screenId == screenId);
    if (index == -1) {
      throw UnsupportedError(
        'Developer: You can only remove screens that exist on the stack '
        '(${screenId.name} not found).',
      );
    }
    _screenStack.removeAt(index);
    _updateScreens();
  }

  bool _inWillShow = false;
  bool _inMayPop = false;
  int _eventCounter = 0;

  Future<void> _navigate(NavigationEvent<SCREEN_ID> navigationEvent) async {
    if (_inWillShow) {
      throw UnsupportedError(
        'Developer: you may not Push or Pop in the willShow method.',
      );
    }
    if (_inMayPop) {
      throw UnsupportedError(
        'Developer: you may not Push or Pop in the mayPop method.',
      );
    }
    late RubigoChangeInfo<SCREEN_ID> changeInfo;
    switch (navigationEvent) {
      case Push<SCREEN_ID>():
        final previousScreen = _screenStack.lastOrNull;
        changeInfo = RubigoChangeInfo<SCREEN_ID>(
          EventType.push,
          previousScreen?.screenId,
          _screenStack.toListOfScreenId(),
        );

        _screenStack.add(
          _availableScreens.find(navigationEvent.screenId),
        );
        _eventCounter++;
        final controller = _screenStack.last.getController();
        if (controller is RubigoControllerMixin) {
          await controller.onTop(changeInfo);
        }
        _eventCounter--;

      case Pop():
        if (_screenStack.isEmpty) {
          return;
        }
        changeInfo = RubigoChangeInfo(
          EventType.pop,
          _screenStack.last.screenId,
          _screenStack.toListOfScreenId(),
        );
        _inMayPop = true;
        final controller = _screenStack.last.getController();
        final bool mayPop;
        if (controller is RubigoControllerMixin) {
          mayPop = await controller.mayPop();
        } else {
          mayPop = true;
        }
        _inMayPop = false;
        if (mayPop) {
          _screenStack.removeLast();
          if (_screenStack.isEmpty) {
            throw UnsupportedError(
              'Developer: Pop was called on the last screen. The screen stack '
              'may not be empty.',
            );
          }
          _eventCounter++;
          final controller = _screenStack.last.getController();
          if (controller is RubigoControllerMixin) {
            await controller.onTop(changeInfo);
          }
          _eventCounter--;
        }
      case PopTo<SCREEN_ID>():
        changeInfo = RubigoChangeInfo(
          EventType.pop,
          _screenStack.last.screenId,
          _screenStack.toListOfScreenId(),
        );
        while (_screenStack.isNotEmpty) {
          _screenStack.removeLast();
          if (_screenStack.isEmpty) {
            throw UnsupportedError(
              'Developer: With popTo, you tried to navigate to '
              '${navigationEvent.screenId.name}, which was not on the stack.',
            );
          }
          if (_screenStack.last.screenId == navigationEvent.screenId) {
            _eventCounter++;
            final controller = _screenStack.last.getController();
            if (controller is RubigoControllerMixin) {
              await controller.onTop(changeInfo);
            }
            _eventCounter--;
            break;
          }
        }

      case ReplaceStack<SCREEN_ID>():
        final previousScreen = _screenStack.last;
        _screenStack =
            navigationEvent.screenStack.toListOfRubigoScreen(_availableScreens);
        changeInfo = RubigoChangeInfo(
          EventType.replaceStack,
          previousScreen.screenId,
          _screenStack.toListOfScreenId(),
        );
        _eventCounter++;
        final controller = _screenStack.last.getController();
        if (controller is RubigoControllerMixin) {
          await controller.onTop(changeInfo);
        }
        _eventCounter--;
    }

    if (_eventCounter == 0) {
      _inWillShow = true;
      {
        final controller = _screenStack.last.getController();
        if (controller is RubigoControllerMixin) {
          await controller.willShow(changeInfo);
        }
      }
      _inWillShow = false;
      _updateScreens();
      await Future<void>.delayed(const Duration(milliseconds: 100));
      final controller = _screenStack.last.getController();
      if (controller is RubigoControllerMixin) {
        await controller.isShown(changeInfo);
      }
    }
  }

  void _updateScreens() {
    screens.value = [..._screenStack];
    unawaited(_logNavigation(screens.value.toListOfScreenId().breadCrumbs()));
  }
}
