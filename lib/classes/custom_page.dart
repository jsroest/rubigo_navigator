import 'package:flutter/material.dart';

class CustomPage<T> extends Page<T> {
  CustomPage({
    @required this.builder,
    @required String name,
    LocalKey key,
  }) : super(key: key ?? ValueKey(name), name: name);
  final WidgetBuilder builder;

  @override
  Route<T> createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: builder,
    );
  }

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
