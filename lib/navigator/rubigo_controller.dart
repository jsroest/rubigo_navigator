import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_rubigo_navigator/navigator/rubigo_material_page.dart';
import 'package:flutter_rubigo_navigator/navigator/rubigo_navigator.dart';
import 'package:flutter_rubigo_navigator/navigator/rubigo_stack_manager.dart';

abstract class RubigoController<PAGE_ENUM> extends ChangeNotifier {
  RubigoController(
    this._page,
  );

  final RubigoMaterialPage _page;

  RubigoMaterialPage get page => _page;

  RubigoNavigator<PAGE_ENUM> _rubigoNavigator;

  RubigoNavigator<PAGE_ENUM> get rubigoNavigator => _rubigoNavigator;

  void init(RubigoNavigator<PAGE_ENUM> rubigoNavigator) {
    _rubigoNavigator = rubigoNavigator;
  }

  FutureOr<void> onTop(
    StackChange stackChange,
    RubigoController previousController,
  ) {}

  FutureOr<void> isShown() {}

  FutureOr<bool> isPopping() => true;
}
