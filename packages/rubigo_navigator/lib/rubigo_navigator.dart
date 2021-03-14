import 'dart:collection';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rubigo_navigator/rubigo.dart';

class RubigoNavigator<PAGE_ENUM> extends ChangeNotifier {
  void init({
    @required LinkedHashMap<PAGE_ENUM, RubigoController<PAGE_ENUM>> controllers,
    @required Widget initialBackground,
    @required GlobalKey<NavigatorState> navigatorState,
  }) {
    _manager = RubigoStackManager<PAGE_ENUM>(controllers, notifyListeners);
    _initialBackground = initialBackground;
    this.navigatorState = navigatorState;
  }

  RubigoStackManager<PAGE_ENUM> _manager;
  Widget _initialBackground;
  GlobalKey<NavigatorState> navigatorState;

  UnmodifiableListView<Page> get pages {
    var stack = _manager.stack;
    if (stack.isEmpty) {
      print('Navigator 2.0: empty');
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
    var pageNames =
        stack.keys.map((e) => EnumToString.convertToString(e)).toList();
    var breadCrumbs = pageNames.join(' => ');
    print('Navigator 2.0: $breadCrumbs');
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
