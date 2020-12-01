import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:flutter_rubigo_navigator/navigator/controller.dart';
import 'package:flutter_rubigo_navigator/navigator/rubigo_controllers.dart';

enum StackChange {
  pushed_on_top,
  returned_from_screen,
}

final rubigoNavigatorProvider = ChangeNotifierProvider<RubigoNavigator>(
  (ref) {
    return RubigoNavigator();
  },
);

class RubigoNavigator extends ChangeNotifier {
  RubigoController _rubigoController;

  void init(RubigoController rubigoController) {
    _rubigoController = rubigoController;
  }

  final _stack = <Controller>[];

  Controller _getController(Type type) {
    return _rubigoController.controllers
        .firstWhere((element) => element.runtimeType == type);
  }

  UnmodifiableListView<Page> get pages {
    if (_stack.isEmpty) {
      push(_rubigoController.initialScreenController);
    }
    return UnmodifiableListView(
      _stack.map((e) => e.page),
    );
  }

  void push(Type type) {
    _stack.add(_getController(type));
    notifyListeners();
  }

  void remove(Type type) {
    _stack.remove(_getController(type));
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
