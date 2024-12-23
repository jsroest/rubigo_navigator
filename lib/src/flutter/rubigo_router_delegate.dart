import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';

class RubigoRouterDelegate<SCREEN_ID extends Enum>
    extends RouterDelegate<SCREEN_ID>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  RubigoRouterDelegate(this._navigator) {
    _navigator.addListener(notifyListeners);
  }

  @override
  GlobalKey<NavigatorState>? get navigatorKey => GlobalKey();

  @override
  Future<void> setNewRoutePath(SCREEN_ID configuration) async {}

  final RubigoNavigator<SCREEN_ID> _navigator;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      pages: _pages,
      //onDidRemovePage: _navigator.onDidRemovePage,
      onPopPage: _navigator.onPopPage,
    );
  }

  List<Page<dynamic>> get _pages {
    return materialPages(_navigator.pages);
  }

  static List<Page<dynamic>> materialPages<SCREEN_ID extends Enum>(
    List<RubigoScreen<SCREEN_ID>> pages,
  ) {
    return pages
        .map(
          (e) => MaterialPage<void>(child: e.screenWidget),
        )
        .toList();
  }

  static List<Page<dynamic>> cupertinoPages<SCREEN_ID extends Enum>(
    List<RubigoScreen<SCREEN_ID>> pages,
  ) {
    return pages
        .map(
          (e) => CupertinoPage<void>(child: e.screenWidget),
        )
        .toList();
  }
}
