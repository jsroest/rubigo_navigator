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
    await _navigate(
      pushOrPop: PushOrPop.pop,
    );
  }

  @override
  Future<void> popTo(SCREEN_ID screenId) async {
    await _navigate(
      pushOrPop: PushOrPop.popTo,
      toScreenId: screenId,
    );
  }

  @override
  Future<void> push(SCREEN_ID screenId) async {
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
        'PANIC: Page must be of type MaterialPage or CupertinoPage',
      );
    }
    final removedScreenId =
        availableScreens.findScreenIdByScreen(removedScreen);
    final lastScreenId = screenStack.last;
    if (removedScreenId != lastScreenId) {
      //onDidRemovePage was initiated by the business logic.
      //In this case the screenStack is already valid
    } else {
      //onDidRemovePage was initiated by the backButton/predictiveBackGesture (Android) or swipeBack (iOS).
      //In this case we still need to adjust the screenStack accordingly
      await pop();
    }
  }

  @override
  void remove(SCREEN_ID screenId) {
    unawaited(_logNavigation('${screenId.name}.remove'));
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
        'Developer: you may not Push or Pop in the willShow method',
      );
    }
    if (_inMayPop) {
      throw UnsupportedError(
        'Developer: you may not Push or Pop in the mayShow method',
      );
    }
    late RubigoChangeInfo<SCREEN_ID> changeInfo;
    switch (pushOrPop) {
      case PushOrPop.push:
        if (toScreenId == null) {
          throw UnsupportedError(
            'Developer: When PushOrPop.push, toController may not be null',
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
        unawaited(_logNavigation('${toScreenId.name}.onTop'));
        await currentController.onTop(changeInfo);
        _pushPopCounter--;

      case PushOrPop.pop:
        if (toScreenId != null) {
          throw UnsupportedError(
            'Developer: When PushOrPop.pop, toController must be null',
          );
        }
        if (screenStack.isEmpty) {
          return;
        }
        var currentScreen = screenStack.last;
        var currentController = availableScreens.findController(currentScreen);
        _inMayPop = true;
        unawaited(_logNavigation('${currentScreen.name}.mayPop'));
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
        currentScreen = screenStack.last;
        currentController = availableScreens.findController(currentScreen);
        _pushPopCounter++;
        unawaited(_logNavigation('${currentScreen.name}.onTop'));
        await currentController.onTop(changeInfo);
        _pushPopCounter--;

      case PushOrPop.popTo:
        if (toScreenId == null) {
          throw UnsupportedError(
            'Developer: When PushOrPop.popTo, toController may not be null',
          );
        }
        changeInfo = RubigoChangeInfo(
          StackChange.isRevealed,
          screenStack.last,
        );
        while (screenStack.length > 1) {
          screenStack.removeLast();
          if (screenStack.last == toScreenId) {
            _pushPopCounter++;
            final currentScreen = screenStack.last;
            final currentController =
                availableScreens.findController(currentScreen);
            unawaited(_logNavigation('${currentScreen.name}.onTop'));
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
      unawaited(_logNavigation('${currentScreen.name}.willShow'));
      await currentController.willShow(changeInfo);
      _inWillShow = false;
      notifyListeners();
      await Future<void>.delayed(const Duration(milliseconds: 100));
      await currentController.isShown(changeInfo);
    }
  }
}
