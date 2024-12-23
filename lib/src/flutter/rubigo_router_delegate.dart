import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';
import 'package:rubigo_navigator/src/flutter/screen_to_page_converters.dart';

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
      pages: screensToMaterialPages(_navigator.screens),
      onDidRemovePage: _navigator.onDidRemovePage,
      //onPopPage: _navigator.onPopPage,
    );
  }
}
