import 'package:flutter/material.dart';
import 'package:flutter_rubigo_navigator/navigator/rubigo_page.dart';
import 'package:flutter_rubigo_navigator/navigator/rubigo_page_controller.dart';

MaterialPageEx<T, U>
    createPage<T extends RubigoPage, U extends RubigoPageController>(
            RubigoPage widget) =>
        MaterialPageEx<T, U>(
          child: widget,
        );

class MaterialPageEx<T, U> extends MaterialPage<T> {
  MaterialPageEx({
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
