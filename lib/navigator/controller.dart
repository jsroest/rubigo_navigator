import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_rubigo_navigator/classes/material_page_ex.dart';
import 'package:flutter_rubigo_navigator/navigator/rubigo_navigator.dart';

class Controller extends ChangeNotifier {
  Controller(this._page);

  final MaterialPageEx _page;

  MaterialPageEx get page => _page;

  FutureOr<void> screenOnTop(
    StackChange stackChange,
    Controller previousScreen,
  ) {}

  FutureOr<void> screenIsShown() {}

  FutureOr<bool> screenIsPopping() {
    return true;
  }
}
