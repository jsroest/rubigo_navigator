import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';

abstract class RubigoController<PAGE_ENUM> extends ChangeNotifier {
  RubigoController(
    this._createRubigoPage,
  );

  final RubigoPage<PAGE_ENUM, RubigoController> Function() _createRubigoPage;

  RubigoMaterialPage get page => RubigoMaterialPage(child: _createRubigoPage());

  late RubigoNavigator<PAGE_ENUM> _rubigoNavigator;

  RubigoNavigator<PAGE_ENUM> get rubigoNavigator => _rubigoNavigator;

  void init(RubigoNavigator<PAGE_ENUM> rubigoNavigator) {
    _rubigoNavigator = rubigoNavigator;
  }

  FutureOr<void> onTop(
    StackChange stackChange,
    PAGE_ENUM? previousPage,
  ) {}

  FutureOr<void> willShow() {}

  FutureOr<bool> mayPop() => true;
}
