import 'package:flutter/foundation.dart';
import 'package:flutter_rubigo_navigator/navigator/rubigo_page_controller.dart';

enum PushOrPop { Push, Pop, PopTo }

enum StackChange {
  pushed_on_top,
  returned_from_controller,
}

class RubigoStackManager {
  RubigoStackManager(
    this.controllers,
    this._notifyListeners,
  ) {
    stack.add(controllers.first);
  }

  final stack = <RubigoPageController>[];
  final List<RubigoPageController> controllers;
  final void Function() _notifyListeners;

  RubigoPageController _getController(Type type) {
    return controllers.firstWhere((element) => element.runtimeType == type);
  }

  void remove(Type type) {
    stack.remove(_getController(type));
    _notifyListeners();
  }

  bool _inIsShown = false;
  bool _inIsPopping = false;
  int _pushPopCounter = 0;

  Future<void> navigate({
    @required PushOrPop pushOrPop,
    Type toController,
  }) async {
    if (_inIsShown) {
      throw 'Developer: you may not Push or Pop in the isShown method';
    }
    if (_inIsPopping) {
      throw 'Developer: you may not Push or Pop in the isPopping method';
    }
    switch (pushOrPop) {
      case PushOrPop.Push:
        final previousController = stack.last;
        stack.add(_getController(toController));
        final currentController = stack.last;
        _pushPopCounter++;
        debugPrint('{$currentController.runtimeType}: onTop');
        await currentController.onTop(
            StackChange.pushed_on_top, previousController);
        _pushPopCounter--;
        break;

      case PushOrPop.Pop:
        if (stack.isNotEmpty) {
          var currentController = stack.last;
          _inIsPopping = true;
          debugPrint('{$currentController.runtimeType}: isPopping');
          var okWithPop = await currentController.isPopping();
          _inIsPopping = false;
          if (!okWithPop) {
            return;
          }
          final previousController = currentController;
          stack.removeLast();
          currentController = stack.last;
          _pushPopCounter++;
          debugPrint('{$currentController.runtimeType}: onTop');
          await currentController.onTop(
              StackChange.returned_from_controller, previousController);
          _pushPopCounter--;
        }
        break;

      case PushOrPop.PopTo:
        final previousController = stack.last;
        while (stack.length > 1) {
          stack.removeLast();
          if (stack.last == _getController(toController)) {
            _pushPopCounter++;
            final currentController = stack.last;
            debugPrint('{$currentController.runtimeType}: onTop');
            await currentController.onTop(
                StackChange.returned_from_controller, previousController);
            _pushPopCounter--;
            break;
          }
        }
        break;
    }
    if (_pushPopCounter == 0) {
      _inIsShown = true;
      final currentController = stack.last;
      debugPrint('{$currentController.runtimeType}: isShown');
      await currentController.isShown();
      _inIsShown = false;
      _notifyListeners();
    }
  }
}
