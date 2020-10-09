import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

enum StackChange {
  pushed_on_top,
  returned_from_screen,
}

class RubigoNavigator extends ChangeNotifier {
  RubigoNavigator(List<Page> initialPages) {
    _pages = initialPages;
  }

  List<Page> _pages;
  UnmodifiableListView<Page> get pages => UnmodifiableListView(_pages);

  void push(Page value) {
    _pages.add(value);
    notifyListeners();
  }

  void remove(Page value) {
    _pages.remove(value);
    notifyListeners();
  }

  bool onPopPage(Route<dynamic> route, dynamic result) {
    _pages.remove(route.settings as Page);
    return route.didPop(result);
  }
}
