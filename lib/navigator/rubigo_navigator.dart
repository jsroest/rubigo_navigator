import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rubigo_navigator/navigator/rubigo_controller.dart';
import 'package:flutter_rubigo_navigator/navigator/rubigo_stack_manager.dart';

// final rubigoNavigatorProvider = ChangeNotifierProvider<RubigoNavigator>(
//   (ref) {
//     return RubigoNavigator();
//   },
// );

class RubigoNavigator<T> extends ChangeNotifier {
  void init({
    @required LinkedHashMap<T, RubigoController> controllers,
  }) {
    _manager = RubigoStackManager<T>(controllers, notifyListeners);
  }

  RubigoStackManager _manager;

  UnmodifiableListView<Page> get pages {
    return UnmodifiableListView(
      _manager.stack.values.map((e) => e.page).toList(),
    );
  }

  Future<void> pop() => _manager.navigate(pushOrPop: PushOrPop.Pop);

  Future<void> push(T id) => _manager.navigate(
        pushOrPop: PushOrPop.Push,
        toController: id,
      );

  Future<void> popTo(T id) => _manager.navigate(
        pushOrPop: PushOrPop.PopTo,
        toController: id,
      );

  void remove(T id) => _manager.remove(id);

  bool onPopPage(Route<dynamic> route, dynamic result) {
    pop();
    return false;
  }
}
