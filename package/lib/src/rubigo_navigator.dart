import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RubigoDelegate<T extends Enum> extends RouterDelegate<List<RouteSettings>>
    with PopNavigatorRouterDelegateMixin<List<RouteSettings>>, ChangeNotifier {
  factory RubigoDelegate({required Page<void> splashPage}) {
    return RubigoDelegate._(splashPage);
  }

  RubigoDelegate._(
    this._splashPage,
  );

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [_splashPage],
    );
  }

  final Page<void> _splashPage;

  @override
  GlobalKey<NavigatorState>? get navigatorKey => GlobalKey<NavigatorState>();

  @override
  Future<void> setNewRoutePath(List<RouteSettings> configuration) {
// TODO: implement setNewRoutePath
    throw UnimplementedError();
  }
}
