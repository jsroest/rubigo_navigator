import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rubigo_navigator/rubigo.dart';

abstract class RubigoController<PAGE_ENUM> extends ChangeNotifier {
  RubigoController(
    this.getRubigoPage,
  );

  final RubigoPage<PAGE_ENUM, RubigoController> Function() getRubigoPage;

  RubigoMaterialPage get page => RubigoMaterialPage(child: getRubigoPage());

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
