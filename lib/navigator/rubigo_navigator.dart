import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rubigo_navigator/navigator/controller.dart';

enum StackChange {
  pushed_on_top,
  returned_from_screen,
}

class RubigoNavigator extends ChangeNotifier {
  RubigoNavigator({
    this.controllers,
    Type initialScreenController,
  }) {
    var screenController = controllers.firstWhere(
        (element) => element.runtimeType == initialScreenController);
    push(screenController);
  }

  T get<T extends Controller>() {
    var screenController =
        controllers.firstWhere((element) => element.runtimeType == T);
    return screenController as T;
  }

  final List<Controller> controllers;
  final _stack = <Controller>[];

  UnmodifiableListView<Page> get pages => UnmodifiableListView(
        _stack.map((e) => e.page),
      );

  void push(Controller value) {
    _stack.add(value);
    notifyListeners();
  }

  void remove(Controller value) {
    _stack.remove(value);
    notifyListeners();
  }

  bool onPopPage(Route<dynamic> route, dynamic result) {
    var controller = _stack.lastWhere(
      (controller) => controller.page == (route.settings as Page),
    );
    _stack.remove(controller);
    return route.didPop(result);
  }
}
