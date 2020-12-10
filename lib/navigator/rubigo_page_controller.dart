import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_rubigo_navigator/classes/material_page_ex.dart';
import 'package:flutter_rubigo_navigator/navigator/rubigo_navigator.dart';
import 'package:flutter_rubigo_navigator/navigator/rubigo_stack_manager.dart';

abstract class RubigoPageController extends ChangeNotifier {
  RubigoPageController(
    this._page,
    this._rubigoNavigator,
  );

  final MaterialPageEx _page;

  MaterialPageEx get page => _page;

  final RubigoNavigator _rubigoNavigator;

  RubigoNavigator get rubigoNavigator => _rubigoNavigator;

  FutureOr<void> onTop(
    StackChange stackChange,
    RubigoPageController previousController,
  ) {}

  FutureOr<void> isShown() {}

  FutureOr<bool> isPopping() => true;
}
