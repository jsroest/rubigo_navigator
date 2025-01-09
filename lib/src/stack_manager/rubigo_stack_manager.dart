import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rubigo_navigator/src/extensions/extensions.dart';
import 'package:rubigo_navigator/src/rubigo_controller.dart';
import 'package:rubigo_navigator/src/rubigo_screen.dart';
import 'package:rubigo_navigator/src/stack_manager/navigation_types/navigation_types.dart';
import 'package:rubigo_navigator/src/stack_manager/rubigo_stack_manager_interface.dart';
import 'package:rubigo_navigator/src/types/rubigo_type_definitions.dart';

class RubigoStackManager<SCREEN_ID extends Enum>
    with ChangeNotifier
    implements RubigoStackManagerInterface<SCREEN_ID> {
  RubigoStackManager(
    this._screenStack,
    this._availableScreens,
    this._logNavigation,
  ) {
    _shadowScreenStack = [..._screenStack];
  }

  //This is the actual screen stack
  ListOfRubigoScreens<SCREEN_ID> _screenStack;

  //This is a shadow of the screen stack;
  ListOfRubigoScreens<SCREEN_ID> _shadowScreenStack = [];

  //This is a list of all available screens
  final ListOfRubigoScreens<SCREEN_ID> _availableScreens;

  final LogNavigation _logNavigation;

  @override
  List<RubigoScreen<SCREEN_ID>> get screens {
    return _shadowScreenStack;
  }

  @override
  Future<void> pop() async {
    unawaited(_logNavigation('pop() called.'));
    await _navigate(Pop<SCREEN_ID>());
  }

  @override
  Future<void> popTo(SCREEN_ID screenId) async {
    unawaited(_logNavigation('popTo(${screenId.name}) called.'));
    await _navigate(PopTo(screenId));
  }

  @override
  Future<void> push(SCREEN_ID screenId) async {
    unawaited(_logNavigation('push(${screenId.name}) called.'));
    await _navigate(Push(screenId));
  }

  @override
  Future<void> replaceStack(List<SCREEN_ID> screens) async {
    unawaited(
      _logNavigation(
        'replaceStack(${screens.map((e) => e.name).join('→')}) called.',
      ),
    );
    await _navigate(ReplaceStack(screens));
  }

  @override
  void remove(SCREEN_ID screenId) {
    unawaited(
      _logNavigation('remove(${screenId.name}) called.'),
    );
    final index = _screenStack.indexWhere((e) => e.screenId == screenId);
    if (index == -1) {
      throw UnsupportedError(
        'Developer: You can only remove screens that exist on the stack (${screenId.name} not found).',
      );
    }
    _screenStack.removeAt(index);
    _notifyListeners();
  }

  bool _inWillShow = false;
  bool _inMayPop = false;
  int _eventCounter = 0;

  Future<void> _navigate(NavigationType<SCREEN_ID> navigationType) async {
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
    switch (navigationType) {
      case Push<SCREEN_ID>():
        final previousScreen = _screenStack.lastOrNull;
        changeInfo = RubigoChangeInfo<SCREEN_ID>(
          EventType.push,
          previousScreen?.screenId,
          _screenStack.toListOfScreenId(),
        );

        _screenStack.add(
          _availableScreens.find(navigationType.screenId),
        );
        _eventCounter++;
        await _screenStack.last.getController().onTop(changeInfo);
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
        final mayPop = await _screenStack.last.getController().mayPop();
        _inMayPop = false;
        if (mayPop) {
          _screenStack.removeLast();
          if (_screenStack.isEmpty) {
            throw UnsupportedError(
              'Developer: Pop was called on the last screen. The screen stack may not be empty.',
            );
          }
          _eventCounter++;
          await _screenStack.last.getController().onTop(changeInfo);
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
              'Developer: With popTo, you tried to navigate to ${navigationType.screenId.name}, which was not on the stack.',
            );
          }
          if (_screenStack.last.screenId == navigationType.screenId) {
            _eventCounter++;
            final currentRubigoScreen = _screenStack.last;
            await currentRubigoScreen.getController().onTop(changeInfo);
            _eventCounter--;
            break;
          }
        }

      case ReplaceStack<SCREEN_ID>():
        final previousScreen = _screenStack.last;
        _screenStack =
            navigationType.screenStack.toListOfRubigoScreen(_availableScreens);
        changeInfo = RubigoChangeInfo(
          EventType.replaceStack,
          previousScreen.screenId,
          _screenStack.toListOfScreenId(),
        );
        _eventCounter++;
        final currentRubigoScreen = _screenStack.last;
        await currentRubigoScreen.getController().onTop(changeInfo);
        _eventCounter--;
    }

    if (_eventCounter == 0) {
      _inWillShow = true;
      await _screenStack.last.getController().willShow(changeInfo);
      _inWillShow = false;
      _notifyListeners();
      await Future<void>.delayed(const Duration(milliseconds: 100));
      await _screenStack.last.getController().isShown(changeInfo);
    }
  }

  void _notifyListeners() {
    _shadowScreenStack = [..._screenStack]; //Create a copy
    notifyListeners();
  }
}
