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
    implements
        RubigoStackManagerInterface<SCREEN_ID, RubigoController<SCREEN_ID>> {
  RubigoStackManager(
    this._screenStack,
    this._availableScreens,
    this._logNavigation,
  );

  //This is the actual screen stack
  ListOfRubigoScreens<SCREEN_ID> _screenStack;

  //This is a list of all available screens
  final ListOfRubigoScreens<SCREEN_ID> _availableScreens;

  final LogNavigation _logNavigation;

  @override
  List<RubigoScreen<SCREEN_ID>> get screens {
    return _screenStack;
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
    notifyListeners();
  }

  @override
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
    final lastScreenId = _screenStack.last.screenId;
    if (removedScreenId != lastScreenId) {
      unawaited(
        _logNavigation('but ignored by us.'),
      );
      //onDidRemovePage was initiated by the business logic.
      //In this case the screenStack is already valid
    } else {
      //onDidRemovePage was initiated by the backButton/predictiveBackGesture (Android) or swipeBack (iOS).
      //In this case we still need to adjust the screenStack accordingly
      unawaited(
        _logNavigation('and redirected to pop().'),
      );
      await pop();
    }
  }

  @Deprecated(
    'Use onDidRemovePage instead. '
    'This feature was deprecated after v3.16.0-17.0.pre.',
  )
  @override
  bool onPopPage(Route<dynamic> route, dynamic result) {
    unawaited(_logNavigation('onPopPage() called by Flutter framework.'));
    unawaited(pop());
    return false;
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
          _availableScreens.findByScreenId(navigationType.screenId),
        );
        _eventCounter++;
        await _screenStack.last.controller.onTop(changeInfo);
        _eventCounter--;

      case Pop():
        if (_screenStack.isEmpty) {
          return;
        }
        _inMayPop = true;
        final mayPop = await _screenStack.last.controller.mayPop();
        _inMayPop = false;
        if (!mayPop) {
          notifyListeners();
          return;
        }

        changeInfo = RubigoChangeInfo(
          EventType.pop,
          _screenStack.last.screenId,
          _screenStack.toListOfScreenId(),
        );
        _screenStack.removeLast();
        if (_screenStack.isEmpty) {
          throw UnsupportedError(
            'Developer: Pop was called on the last screen. The screen stack may not be empty.',
          );
        }
        _eventCounter++;
        await _screenStack.last.controller.onTop(changeInfo);
        _eventCounter--;

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
            await currentRubigoScreen.controller.onTop(changeInfo);
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
        await currentRubigoScreen.controller.onTop(changeInfo);
        _eventCounter--;
    }

    if (_eventCounter == 0) {
      _inWillShow = true;
      await _screenStack.last.controller.willShow(changeInfo);
      _inWillShow = false;
      notifyListeners();
      await Future<void>.delayed(const Duration(milliseconds: 100));
      await _screenStack.last.controller.isShown(changeInfo);
    }
  }
}
