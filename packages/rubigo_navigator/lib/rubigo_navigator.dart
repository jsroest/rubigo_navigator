library rubigo_navigator;

import 'dart:async';
import 'dart:collection';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';

export 'rubigo_app.dart';
export 'rubigo_controller.dart';
export 'rubigo_material_page.dart';
export 'rubigo_navigator.dart';
export 'rubigo_page.dart';
export 'rubigo_stack_manager.dart';

class RubigoNavigator<PAGE_ENUM> extends ChangeNotifier {
  void init({
    required LinkedHashMap<PAGE_ENUM, RubigoController<PAGE_ENUM>> controllers,
    required Widget? initialBackground,
    required GlobalKey<NavigatorState> navigatorState,
    required void Function(String value) log,
  }) {
    this.log = log;
    _manager = RubigoStackManager<PAGE_ENUM>(controllers, notifyListeners, log);
    _initialBackground = initialBackground;
    this.navigatorState = navigatorState;
  }

  late RubigoStackManager<PAGE_ENUM> _manager;
  late Widget? _initialBackground;
  late GlobalKey<NavigatorState> navigatorState;
  late void Function(String value) log;

  UnmodifiableListView<Page> get pages {
    var stack = _manager.stack;
    if (stack.isEmpty) {
      log('Navigator 2.0: Empty pages list');
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
    log('Navigator 2.0: $breadCrumbs');
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
