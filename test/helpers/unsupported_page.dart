import 'package:flutter/widgets.dart';

class UnsupportedPage<T> extends Page<T> {
  const UnsupportedPage({
    required this.child,
  });

  final Widget child;

  @override
  Route<T> createRoute(BuildContext context) {
    // TODO: implement createRoute
    throw UnimplementedError();
  }
}
