import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_rubigo_navigator/classes/material_page_ex.dart';
import 'package:flutter_rubigo_navigator/navigator/rubigo_navigator.dart';

class Controller extends ChangeNotifier {
  Controller(
    this._page,
    this._rubigoNavigator,
  );

  final MaterialPageEx _page;

  MaterialPageEx get page => _page;

  final RubigoNavigator _rubigoNavigator;

  RubigoNavigator get rubigoNavigator => _rubigoNavigator;

  @mustCallSuper
  FutureOr<void> onTop(
    StackChange stackChange,
    Controller previousController,
  ) {
    debugPrint('$runtimeType: onTop');
  }

  @mustCallSuper
  FutureOr<void> isShown() {
    debugPrint('$runtimeType: isShown');
  }

  @mustCallSuper
  FutureOr<bool> isPopping() {
    debugPrint('$runtimeType: isPopping');
    return true;
  }
}
