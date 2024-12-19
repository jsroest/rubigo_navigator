import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rubigo_navigator/src/extensions/extensions.dart';
import 'package:rubigo_navigator/src/rubigo_controller.dart';
import 'package:rubigo_navigator/src/stack_manager/navigation_types/navigation_types.dart';
import 'package:rubigo_navigator/src/stack_manager/rubigo_stack_manager_interface.dart';
import 'package:rubigo_navigator/src/types/rubigo_type_definitions.dart';

class RubigoStackManager<SCREEN_ID extends Enum>
    with ChangeNotifier
    implements RubigoStackManagerInterface<SCREEN_ID> {
  RubigoStackManager(
    this.screenStack,
    this.availableScreens,
    this._screenToPage,
    this._logNavigation,
  );

  //This is the actual screen stack
  final List<SCREEN_ID> screenStack;

  //This is a list of all available screens
  final ListOfRubigoScreens<SCREEN_ID> availableScreens;

  final LogNavigation _logNavigation;

  final ScreenToPage _screenToPage;

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
        changeInfo = RubigoChangeInfo(
          StackChange.isPushed,
          previousScreen,
        );
        final currentController =
            availableScreens.findController(navigationType.screenId);
        screenStack.add(navigationType.screenId);
        _pushPopCounter++;
        await currentController.onTop(changeInfo);
        _pushPopCounter--;

      case Pop():
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

      case PopTo<SCREEN_ID>():
        changeInfo = RubigoChangeInfo(
          StackChange.isRevealed,
          screenStack.last,
        );
        while (screenStack.isNotEmpty) {
          screenStack.removeLast();
          if (screenStack.isEmpty) {
            throw UnsupportedError(
              'Developer: With popTo, you tried to navigate to ${navigationType.screenId.name}, which was not on the stack.',
            );
          }
          if (screenStack.last == navigationType.screenId) {
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

  @override
  // TODO: implement pages
  List<Page<void>> get pages {
    unawaited(
      _logNavigation(
        'Screen stack: ${screenStack.map((e) => e.name).toList().join(' => ')}.',
      ),
    );
    final pages = screenStack
        .map(availableScreens.findScreen)
        .map(_screenToPage)
        .toList();
    return pages;
  }
}
