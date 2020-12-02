import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:flutter_rubigo_navigator/navigator/controller.dart';
import 'package:flutter_rubigo_navigator/navigator/rubigo_stack_manager.dart';

final rubigoNavigatorProvider = ChangeNotifierProvider<RubigoNavigator>(
  (ref) {
    return RubigoNavigator();
  },
);

class RubigoNavigator extends ChangeNotifier {
  void init({
    @required List<Controller> controllers,
  }) {
    _manager = RubigoStackManager(controllers, notifyListeners);
  }

  RubigoStackManager _manager;

  UnmodifiableListView<Page> get pages =>
      UnmodifiableListView(_manager.stack.map((e) => e.page));

  Future<void> pop() => _manager.navigate(pushOrPop: PushOrPop.Pop);

  Future<void> push(Type controller) => _manager.navigate(
        pushOrPop: PushOrPop.Push,
        toController: controller,
      );

  Future<void> popTo(Type controller) => _manager.navigate(
        pushOrPop: PushOrPop.PopTo,
        toController: controller,
      );

  void remove(Type type) => _manager.remove(type);

  bool onPopPage(Route<dynamic> route, dynamic result) {
    pop();
    return false;
  }
}
