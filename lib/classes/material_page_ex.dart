import 'package:flutter/material.dart';

class MaterialPageEx<T> extends MaterialPage<T> {
  MaterialPageEx({
    @required child,
    maintainState = true,
    fullscreenDialog = false,
    LocalKey key,
    String name,
    Object arguments,
  }) : super(
          child: child,
          maintainState: maintainState,
          fullscreenDialog: fullscreenDialog,
          key: key ?? ValueKey(name),
          name: name,
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
