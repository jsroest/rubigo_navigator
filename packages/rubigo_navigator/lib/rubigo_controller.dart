import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:rubigo_navigator/rubigo.dart';
import 'package:rubigo_navigator/rubigo_stack_manager.dart';

abstract class RubigoController<PAGE_ENUM> extends ChangeNotifier {
  RubigoController(
    RubigoPage<PAGE_ENUM, RubigoController<PAGE_ENUM>> rubigoPage,
  ) : _rubigoPage = createPage(rubigoPage);

  final RubigoMaterialPage _rubigoPage;

  RubigoMaterialPage get page => _rubigoPage;

  RubigoNavigator<PAGE_ENUM> _rubigoNavigator;

  RubigoNavigator<PAGE_ENUM> get rubigoNavigator => _rubigoNavigator;

  void init(RubigoNavigator<PAGE_ENUM> rubigoNavigator) {
    _rubigoNavigator = rubigoNavigator;
  }

  FutureOr<void> onTop(
    StackChange stackChange,
    PAGE_ENUM previousPage,
  ) {}

  FutureOr<void> isShown() {}

  FutureOr<bool> isPopping() => true;
}
