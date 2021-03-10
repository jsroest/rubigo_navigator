import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rubigo_navigator/rubigo.dart';
import 'package:rubigo_navigator/rubigo_stack_manager.dart';

class RubigoNavigator<PAGE_ENUM> extends ChangeNotifier {
  void init({
    @required LinkedHashMap<PAGE_ENUM, RubigoController<PAGE_ENUM>> controllers,
    @required Widget initialBackground,
  }) {
    _manager = RubigoStackManager<PAGE_ENUM>(controllers, notifyListeners);
    _initialBackground = initialBackground;
  }

  RubigoStackManager<PAGE_ENUM> _manager;
  Widget _initialBackground;

  UnmodifiableListView<Page> get pages {
    var stack = _manager.stack;
    if (stack.isEmpty) {
      return UnmodifiableListView(
        [
          MaterialPage(
            child: _initialBackground ??
                Container(
                  color: Colors.white,
                ),
          ),
        ],
      );
    }
    return UnmodifiableListView(
      stack.values.map((e) => e.page).toList(),
    );
  }

  LinkedHashMap<PAGE_ENUM, RubigoController<PAGE_ENUM>> get stack {
    return _manager.stack;
  }

  Future<void> pop() => _manager.navigate(pushOrPop: PushOrPop.Pop);

  Future<void> push(PAGE_ENUM id) => _manager.navigate(
        pushOrPop: PushOrPop.Push,
        toController: id,
      );

  Future<void> popTo(PAGE_ENUM id) => _manager.navigate(
        pushOrPop: PushOrPop.PopTo,
        toController: id,
      );

  void remove(PAGE_ENUM id) => _manager.remove(id);

  bool onPopPage(Route<dynamic> route, dynamic result) {
    pop();
    return false;
  }
}
