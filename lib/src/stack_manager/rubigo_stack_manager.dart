import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rubigo_navigator/src/extensions/extensions.dart';
import 'package:rubigo_navigator/src/rubigo_controller.dart';
import 'package:rubigo_navigator/src/stack_manager/rubigo_stack_manager_interface.dart';
import 'package:rubigo_navigator/src/types/rubigo_type_definitions.dart';

enum PushOrPop { push, pop, popTo }

class RubigoStackManager<SCREEN_ID extends Enum>
    with ChangeNotifier
    implements RubigoStackManagerInterface<SCREEN_ID> {
  RubigoStackManager(
    this.screenStack,
    this.availableScreens,
    this._logNavigation,
  );

  //This is the actual screen stack
  @override
  final List<SCREEN_ID> screenStack;

  //This is a list of all available screens
  @override
  final ListOfRubigoScreens<SCREEN_ID> availableScreens;

  final LogNavigation _logNavigation;

  @override
  Future<void> pop() async {
    unawaited(_logNavigation('pop() called.'));
    await _navigate(
      pushOrPop: PushOrPop.pop,
    );
  }

  @override
  Future<void> popTo(SCREEN_ID screenId) async {
    unawaited(_logNavigation('popTo(${screenId.name}) called.'));
    await _navigate(
      pushOrPop: PushOrPop.popTo,
      toScreenId: screenId,
    );
  }

  @override
  Future<void> push(SCREEN_ID screenId) async {
    unawaited(_logNavigation('push(${screenId.name}) called.'));
    await _navigate(
      pushOrPop: PushOrPop.push,
      toScreenId: screenId,
    );
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
    final lastScreenId = screenStack.last;
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
  Future<bool> onPopPage(Route<dynamic> route, dynamic result) async {
    unawaited(
      _logNavigation('onPopPage() called by Flutter framework.'),
    );
    await pop();
    return false;
  }

  @override
  void remove(SCREEN_ID screenId) {
    unawaited(
      _logNavigation('remove(${screenId.name}) called.'),
    );
    if (!screenStack.contains(screenId)) {
      throw UnsupportedError(
        'Developer: You can only remove pages that exist on the stack (${screenId.name} not found).',
      );
    }
    screenStack.remove(screenId);
    notifyListeners();
  }

  bool _inWillShow = false;
  bool _inMayPop = false;
  int _pushPopCounter = 0;

  Future<void> _navigate({
    required PushOrPop pushOrPop,
    SCREEN_ID? toScreenId,
  }) async {
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
    switch (pushOrPop) {
      case PushOrPop.push:
        if (toScreenId == null) {
          throw UnsupportedError(
            'Developer: When calling push, parameter toController may not be null.',
          );
        }
        final previousScreen = screenStack.lastOrNull;

        changeInfo = RubigoChangeInfo(
          StackChange.isPushed,
          previousScreen,
        );
        final currentController = availableScreens.findController(toScreenId);
        screenStack.add(toScreenId);
        _pushPopCounter++;
        await currentController.onTop(changeInfo);
        _pushPopCounter--;

      case PushOrPop.pop:
        if (toScreenId != null) {
          throw UnsupportedError(
            'Developer: When PushOrPop.pop, toController must be null.',
          );
        }
        if (screenStack.isEmpty) {
          return;
        }
        var currentScreen = screenStack.last;
        var currentController = availableScreens.findController(currentScreen);
        _inMayPop = true;
        final mayPop = await currentController.mayPop();
        _inMayPop = false;
        if (!mayPop) {
          return;
        }
        final previousScreen = currentScreen;
        changeInfo = RubigoChangeInfo(
          StackChange.isRevealed,
          previousScreen,
        );
        screenStack.removeLast();
        if (screenStack.isEmpty) {
          throw UnsupportedError(
            'Developer: Pop was called on the last page. The screen stack may not be empty.',
          );
        }
        currentScreen = screenStack.last;
        currentController = availableScreens.findController(currentScreen);
        _pushPopCounter++;
        await currentController.onTop(changeInfo);
        _pushPopCounter--;

      case PushOrPop.popTo:
        if (toScreenId == null) {
          throw ArgumentError(
            'Developer: With popTo, the toController parameter may not be null.',
          );
        }
        changeInfo = RubigoChangeInfo(
          StackChange.isRevealed,
          screenStack.last,
        );
        while (screenStack.isNotEmpty) {
          screenStack.removeLast();
          if (screenStack.isEmpty) {
            throw UnsupportedError(
              'Developer: With popTo, you tried to navigate to ${toScreenId.name}, which was not on the stack.',
            );
          }
          if (screenStack.last == toScreenId) {
            _pushPopCounter++;
            final currentScreen = screenStack.last;
            final currentController =
                availableScreens.findController(currentScreen);
            await currentController.onTop(changeInfo);
            _pushPopCounter--;
            break;
          }
        }
    }
    if (_pushPopCounter == 0) {
      _inWillShow = true;
      final currentScreen = screenStack.last;
      final currentController = availableScreens.findController(currentScreen);
      await currentController.willShow(changeInfo);
      _inWillShow = false;
      notifyListeners();
      await Future<void>.delayed(const Duration(milliseconds: 100));
      await currentController.isShown(changeInfo);
    }
  }
}
