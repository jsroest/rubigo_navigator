import 'package:flutter/material.dart';
import 'package:flutter_rubigo_navigator/navigator/rubigo_controller.dart';
import 'package:flutter_rubigo_navigator/navigator/rubigo_page.dart';

RubigoMaterialPage<P, T, U> createPage<
        P,
        T extends RubigoPage<P, RubigoController<P>>,
        U extends RubigoController<P>>(RubigoPage widget) =>
    RubigoMaterialPage<P, T, U>(
      child: widget,
    );

class RubigoMaterialPage<P, T extends RubigoPage<P, RubigoController<P>>, U>
    extends MaterialPage<T> {
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
