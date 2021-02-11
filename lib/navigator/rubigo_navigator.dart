import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:flutter_rubigo_navigator/navigator/rubigo_controller.dart';
import 'package:flutter_rubigo_navigator/navigator/rubigo_stack_manager.dart';

final rubigoNavigatorProvider = ChangeNotifierProvider<RubigoNavigator>(
  (ref) {
    return RubigoNavigator();
  },
);

class RubigoNavigator extends ChangeNotifier {
  void init({
    @required LinkedHashMap<String, RubigoController> controllers,
  }) {
    _manager = RubigoStackManager(controllers, notifyListeners);
  }

  RubigoStackManager _manager;

  UnmodifiableListView<Page> get pages {
    return UnmodifiableListView(
      _manager.stack
          .map<String, Page<dynamic>>((k, v) => MapEntry(k, v.page))
          .values
          .toList(),
    );
  }

  Future<void> pop() => _manager.navigate(pushOrPop: PushOrPop.Pop);

  Future<void> push(String id) => _manager.navigate(
        pushOrPop: PushOrPop.Push,
        toController: id,
      );

  Future<void> popTo(String id) => _manager.navigate(
        pushOrPop: PushOrPop.PopTo,
        toController: id,
      );

  void remove(String id) => _manager.remove(id);

  bool onPopPage(Route<dynamic> route, dynamic result) {
    pop();
    return false;
  }
}
