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
    this.screenStack,
    this.availableScreens,
    this._logNavigation,
  );

  //This is the actual screen stack
  final ListOfRubigoScreens<SCREEN_ID> screenStack;

  //This is a list of all available screens
  final ListOfRubigoScreens<SCREEN_ID> availableScreens;

  final LogNavigation _logNavigation;

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
  Future<void> onDidRemovePage(Page<Object?> page) async {
    late final Widget removedScreen;
    if (page is MaterialPage) {
      removedScreen = page.child;
    } else if (page is CupertinoPage) {
      removedScreen = page.child;
    } else {
      throw UnsupportedError(
        'PANIC: Page must be of type MaterialPage or CupertinoPage.',
      );
    }
    final removedScreenId =
        availableScreens.findScreenIdByScreen(removedScreen);
    unawaited(
      _logNavigation(
        'onDidRemovePage(${removedScreenId.name}) called by Flutter framework.',
      ),
    );
    final lastScreenId = screenStack.last.screenId;
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

  @override
  bool onPopPage(Route<dynamic> route, dynamic result) {
    unawaited(_logNavigation('onPopPage() called by Flutter framework.'));
    unawaited(pop());
    return false;
  }

  @override
  void remove(SCREEN_ID screenId) {
    unawaited(
      _logNavigation('remove(${screenId.name}) called.'),
    );
    final index = screenStack.indexWhere((e) => e.screenId == screenId);
    if (index == -1) {
      throw UnsupportedError(
        'Developer: You can only remove screens that exist on the stack (${screenId.name} not found).',
      );
    }
    screenStack.removeAt(index);
    notifyListeners();
  }

  bool _inWillShow = false;
  bool _inMayPop = false;
  int _pushPopCounter = 0;

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
        final previousScreen = screenStack.lastOrNull;
        changeInfo = RubigoChangeInfo<SCREEN_ID>(
          StackChange.isPushed,
          previousScreen?.screenId,
        );

        screenStack.add(
          availableScreens.firstWhere(
            (e) => e.screenId == navigationType.screenId,
          ),
        );
        _pushPopCounter++;
        await screenStack.last.controller.onTop(changeInfo);
        _pushPopCounter--;

      case Pop():
        if (screenStack.isEmpty) {
          return;
        }
        _inMayPop = true;
        final mayPop = await screenStack.last.controller.mayPop();
        _inMayPop = false;
        if (!mayPop) {
          return;
        }

        changeInfo = RubigoChangeInfo(
          StackChange.isRevealed,
          screenStack.last.screenId,
        );
        screenStack.removeLast();
        if (screenStack.isEmpty) {
          throw UnsupportedError(
            'Developer: Pop was called on the last screen. The screen stack may not be empty.',
          );
        }
        _pushPopCounter++;
        await screenStack.last.controller.onTop(changeInfo);
        _pushPopCounter--;

      case PopTo<SCREEN_ID>():
        changeInfo = RubigoChangeInfo(
          StackChange.isRevealed,
          screenStack.last.screenId,
        );
        while (screenStack.isNotEmpty) {
          screenStack.removeLast();
          if (screenStack.isEmpty) {
            throw UnsupportedError(
              'Developer: With popTo, you tried to navigate to ${navigationType.screenId.name}, which was not on the stack.',
            );
          }
          if (screenStack.last.screenId == navigationType.screenId) {
            _pushPopCounter++;
            final currentRubigoScreen = screenStack.last;
            await currentRubigoScreen.controller.onTop(changeInfo);
            _pushPopCounter--;
            break;
          }
        }
    }
    if (_pushPopCounter == 0) {
      _inWillShow = true;
      await screenStack.last.controller.willShow(changeInfo);
      _inWillShow = false;
      notifyListeners();
      await Future<void>.delayed(const Duration(milliseconds: 100));
      await screenStack.last.controller.isShown(changeInfo);
    }
  }

  @override
  List<RubigoScreen<SCREEN_ID>> get screens {
    unawaited(
      _logNavigation(
        'Screen stack: ${screenStack.map((e) => e.screenId.name).toList().join(' => ')}.',
      ),
    );
    return screenStack;
  }
}
