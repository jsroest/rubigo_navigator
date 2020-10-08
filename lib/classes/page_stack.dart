import 'dart:collection';

import 'package:flutter/material.dart';

class PageStack extends ChangeNotifier {
  PageStack(List<Page> initialPages) {
    _pages = initialPages;
  }
  List<Page> _pages = <Page>[];
  UnmodifiableListView<Page> get pages => UnmodifiableListView(_pages);

  void add(Page value) {
    _pages.add(value);
    notifyListeners();
  }

  void remove(Page value) {
    _pages.remove(value);
    notifyListeners();
  }
}
