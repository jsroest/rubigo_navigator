import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_rubigo_navigator/navigator/rubigo_material_page.dart';
import 'package:flutter_rubigo_navigator/navigator/rubigo_navigator.dart';
import 'package:flutter_rubigo_navigator/navigator/rubigo_stack_manager.dart';

abstract class RubigoController<T> extends ChangeNotifier {
  RubigoController(
    this._page,
    this._rubigoNavigator,
  );

  final RubigoMaterialPage _page;

  RubigoMaterialPage get page => _page;

  final RubigoNavigator<T> _rubigoNavigator;

  RubigoNavigator<T> get rubigoNavigator => _rubigoNavigator;

  FutureOr<void> onTop(
    StackChange stackChange,
    RubigoController previousController,
  ) {}

  FutureOr<void> isShown() {}

  FutureOr<bool> isPopping() => true;
}
