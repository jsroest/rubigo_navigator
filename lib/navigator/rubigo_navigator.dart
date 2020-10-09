import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rubigo_navigator/classes/page_stack.dart';
import 'package:flutter_rubigo_navigator/pages/s010_login/s010_login.page.dart';

enum StackChange {
  pushed_on_top,
  returned_from_screen,
}

class RubigoNavigator extends ChangeNotifier {
  RubigoNavigator() {
    _pageStack = PageStack([S010LoginPage.page]);
  }

  PageStack _pageStack;

  UnmodifiableListView<Page> get pages => _pageStack.pages;

  void push(Page value) {
    _pageStack.push(value);
    notifyListeners();
  }

  void remove(Page value) {
    _pageStack.remove(value);
    notifyListeners();
  }

  bool onPopPage(Route<dynamic> route, dynamic result) {
    _pageStack.remove(route.settings as Page);
    return route.didPop(result);
  }
}
