import 'dart:async';
import 'dart:collection';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';

enum PushOrPop { Push, Pop, PopTo }

enum StackChange {
  pushed_on_top,
  returned_from_controller,
}

class RubigoStackManager<PAGE_ENUM> {
  RubigoStackManager(
    this.controllers,
    this._notifyListeners,
    this.log,
  ) {
    WidgetsBinding.instance!.addPostFrameCallback(
      (timeStamp) async {
        await navigate(
            pushOrPop: PushOrPop.Push, toController: controllers.keys.first);
      },
    );
  }

  final stack = LinkedHashMap<PAGE_ENUM, RubigoController<PAGE_ENUM>>();
  final LinkedHashMap<PAGE_ENUM, RubigoController<PAGE_ENUM>> controllers;
  final void Function() _notifyListeners;
  void Function(String value) log;

  void remove(PAGE_ENUM key) {
    log('${EnumToString.convertToString(key)}.remove');
    stack.remove(key);
    _notifyListeners();
  }

  bool _inWillShow = false;
  bool _inMayPop = false;
  int _pushPopCounter = 0;

  Future<void> navigate({
    required PushOrPop pushOrPop,
    PAGE_ENUM? toController,
  }) async {
    if (_inWillShow) {
      throw 'Developer: you may not Push or Pop in the willShow method';
    }
    if (_inMayPop) {
      throw 'Developer: you may not Push or Pop in the mayShow method';
    }
    switch (pushOrPop) {
      case PushOrPop.Push:
        if (toController == null) {
          throw FormatException('Push: toController may not be null');
        }
        final previousController =
            stack.entries.isNotEmpty ? stack.entries.last : null;
        final currentController = controllers[toController]!;
        stack[toController] = currentController;
        _pushPopCounter++;
        log('${EnumToString.convertToString(toController)}.onTop');
        await currentController.onTop(
            StackChange.pushed_on_top, previousController?.key);
        _pushPopCounter--;
        break;

      case PushOrPop.Pop:
        if (toController != null) {
          throw FormatException('Pop: toController must be null');
        }
        if (stack.isNotEmpty) {
          var currentController = stack.entries.last;
          _inMayPop = true;
          log('${EnumToString.convertToString(currentController.key)}.mayPop');
          var okWithPop = await currentController.value.mayPop();
          _inMayPop = false;
          if (!okWithPop) {
            return;
          }
          final previousController = currentController;
          stack.remove(currentController.key);
          currentController = stack.entries.last;
          _pushPopCounter++;
          log('${EnumToString.convertToString(currentController.key)}.onTop');
          await currentController.value.onTop(
              StackChange.returned_from_controller, previousController.key);
          _pushPopCounter--;
        }
        break;

      case PushOrPop.PopTo:
        if (toController == null) {
          throw FormatException('PopTo: toController may not be null');
        }
        while (stack.length > 1) {
          final previousController = stack.entries.last;
          stack.remove(previousController.key);
          if (stack.entries.last.key == toController) {
            _pushPopCounter++;
            final currentController = stack.entries.last;
            log('${EnumToString.convertToString(currentController.key)}.onTop');
            await currentController.value.onTop(
                StackChange.returned_from_controller, previousController.key);
            _pushPopCounter--;
            break;
          }
        }
        break;
    }
    if (_pushPopCounter == 0) {
      _inWillShow = true;
      final currentController = stack.entries.last;
      log('${EnumToString.convertToString(currentController.key)}.willShow');
      await currentController.value.willShow();
      _inWillShow = false;
      _notifyListeners();
    }
  }
}
