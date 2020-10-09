import 'dart:collection';

import 'package:flutter/material.dart';

class PageStack {
  PageStack(List<Page> initialPages) {
    _pages = initialPages;
  }

  List<Page> _pages = <Page>[];

  UnmodifiableListView<Page> get pages => UnmodifiableListView(_pages);

  void push(Page value) {
    _pages.add(value);
  }

  void remove(Page value) {
    _pages.remove(value);
  }
}
