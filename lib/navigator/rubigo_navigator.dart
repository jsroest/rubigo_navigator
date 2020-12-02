import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:flutter_rubigo_navigator/navigator/controller.dart';

enum StackChange {
  pushed_on_top,
  returned_from_controller,
}

enum PushOrPop { Push, Pop, PopTo }

final rubigoNavigatorProvider = ChangeNotifierProvider<RubigoNavigator>(
  (ref) {
    return RubigoNavigator();
  },
);

class RubigoNavigator extends ChangeNotifier {
  void init({
    @required List<Controller> controllers,
  }) {
    _controllers = controllers;
  }

  List<Controller> _controllers;

  final _stack = <Controller>[];

  Controller _getController(Type type) {
    return _controllers.firstWhere((element) => element.runtimeType == type);
  }

  UnmodifiableListView<Page> get pages {
    if (_stack.isEmpty) {
      _stack.add(_controllers.first);
    }
    return UnmodifiableListView(
      _stack.map((e) => e.page),
    );
  }

  Future<void> pop() => _pushOrPopController(PushOrPop.Pop, null);

  Future<void> push(Type controller) => _pushOrPopController(
        PushOrPop.Push,
        controller,
      );

  Future<void> popTo(Type controller) => _pushOrPopController(
        PushOrPop.PopTo,
        controller,
      );

  void remove(Type type) {
    _stack.remove(_getController(type));
    notifyListeners();
  }

  bool onPopPage(Route<dynamic> route, dynamic result) {
    pop();
    return false;
  }

  bool _inIsShown = false;
  bool _inIsPopping = false;
  int _pushPopCounter = 0;

  Future<void> _pushOrPopController(
    PushOrPop pushOrPop,
    Type toController,
  ) async {
    if (_inIsShown) {
      throw 'Developer: you may not Push or Pop in the isShown method';
    }
    if (_inIsPopping) {
      throw 'Developer: you may not Push or Pop in the isPopping method';
    }
    switch (pushOrPop) {
      case PushOrPop.Push:
        final previousController = _stack.last;
        _stack.add(_getController(toController));
        final currentController = _stack.last;
        _pushPopCounter++;
        await currentController.onTop(
            StackChange.pushed_on_top, previousController);
        _pushPopCounter--;
        break;

      case PushOrPop.Pop:
        if (_stack.isNotEmpty) {
          var currentController = _stack.last;
          _inIsPopping = true;
          var okWithPop = await currentController.isPopping();
          _inIsPopping = false;
          if (!okWithPop) {
            return;
          }
          final previousController = currentController;
          _stack.removeLast();
          currentController = _stack.last;
          _pushPopCounter++;
          await currentController.onTop(
              StackChange.returned_from_controller, previousController);
          _pushPopCounter--;
        }
        break;

      case PushOrPop.PopTo:
        final previousController = _stack.last;
        while (_stack.length > 1) {
          _stack.removeLast();
          if (_stack.last == _getController(toController)) {
            _pushPopCounter++;
            final currentController = _stack.last;
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
      final currentController = _stack.last;
      await currentController.isShown();
      _inIsShown = false;
      notifyListeners();
    }
  }
}
