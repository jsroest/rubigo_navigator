// @dart=2.9

import 'package:flutter/material.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';
import 'package:rubigo_navigator/rubigo_page.dart';

class RubigoMaterialPage<
    PAGES_ENUM,
    RUBIGO_PAGE extends RubigoPage<PAGES_ENUM,
        RubigoController<PAGES_ENUM>>> extends MaterialPage<RUBIGO_PAGE> {
  RubigoMaterialPage({
    @required Widget child,
    bool maintainState = true,
    bool fullscreenDialog = false,
    LocalKey key,
    Object arguments,
  }) : super(
          child: child,
          maintainState: maintainState,
          fullscreenDialog: fullscreenDialog,
          key: key ?? ValueKey(child.toString()),
          name: child.toString(),
          arguments: arguments,
        );

  @override
  int get hashCode => key.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is Page) {
      return key == other.key;
    } else {
      return super == other;
    }
  }
}
