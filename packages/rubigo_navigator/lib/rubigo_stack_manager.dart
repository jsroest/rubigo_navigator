import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:rubigo_navigator/rubigo.dart';

enum PushOrPop { Push, Pop, PopTo }

enum StackChange {
  pushed_on_top,
  returned_from_controller,
}

class RubigoStackManager<PAGE_ENUM> {
  RubigoStackManager(
    this.controllers,
    this._notifyListeners,
  ) {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        await navigate(
            pushOrPop: PushOrPop.Push, toController: controllers.keys.first);
      },
    );
  }

  final stack = <PAGE_ENUM, RubigoController<PAGE_ENUM>>{};
  final LinkedHashMap<PAGE_ENUM, RubigoController<PAGE_ENUM>> controllers;
  final void Function() _notifyListeners;

  void remove(PAGE_ENUM key) {
    debugPrint('$key: remove');
    stack.remove(key);
    _notifyListeners();
  }

  bool _inIsShown = false;
  bool _inIsPopping = false;
  int _pushPopCounter = 0;

  Future<void> navigate({
    @required PushOrPop pushOrPop,
    PAGE_ENUM toController,
  }) async {
    if (_inIsShown) {
      throw 'Developer: you may not Push or Pop in the isShown method';
    }
    if (_inIsPopping) {
      throw 'Developer: you may not Push or Pop in the isPopping method';
    }
    switch (pushOrPop) {
      case PushOrPop.Push:
        final previousController =
            stack.entries.isNotEmpty ? stack.entries.last : null;
        final currentController = controllers[toController];
        stack[toController] = currentController;
        _pushPopCounter++;
        debugPrint('$toController: onTop');
        await currentController.onTop(
            StackChange.pushed_on_top, previousController?.key);
        _pushPopCounter--;
        break;

      case PushOrPop.Pop:
        if (stack.isNotEmpty) {
          var currentController = stack.entries.last;
          _inIsPopping = true;
          debugPrint('${currentController.key}: isPopping');
          var okWithPop = await currentController.value.isPopping();
          _inIsPopping = false;
          if (!okWithPop) {
            return;
          }
          final previousController = currentController;
          stack.remove(currentController.key);
          currentController = stack.entries.last;
          _pushPopCounter++;
          debugPrint('${currentController.key}: onTop');
          await currentController.value.onTop(
              StackChange.returned_from_controller, previousController.key);
          _pushPopCounter--;
        }
        break;

      case PushOrPop.PopTo:
        while (stack.length > 1) {
          final previousController = stack.entries.last;
          stack.remove(previousController.key);
          if (stack.entries.last.key == toController) {
            _pushPopCounter++;
            final currentController = stack.entries.last;
            debugPrint('${currentController.key}: onTop');
            await currentController.value.onTop(
                StackChange.returned_from_controller, previousController.key);
            _pushPopCounter--;
            break;
          }
        }
        break;
    }
    if (_pushPopCounter == 0) {
      _inIsShown = true;
      final currentController = stack.entries.last;
      debugPrint('${currentController.key}: isShown');
      await currentController.value.isShown();
      _inIsShown = false;
      _notifyListeners();
    }
  }
}
