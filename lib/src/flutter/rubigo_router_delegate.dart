import 'package:flutter/material.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';
import 'package:rubigo_navigator/src/flutter/screen_to_page_converters.dart';

class RubigoRouterDelegate<SCREEN_ID extends Enum>
    extends RouterDelegate<SCREEN_ID>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  RubigoRouterDelegate(this._rubigoRouter) {
    _rubigoRouter.addListener(notifyListeners);
  }

  @override
  GlobalKey<NavigatorState>? get navigatorKey => GlobalKey();

  @override
  Future<void> setNewRoutePath(SCREEN_ID configuration) async {}

  final RubigoRouter<SCREEN_ID> _rubigoRouter;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      pages: _rubigoRouter.isInitialized
          ? _rubigoRouter.screens.toMaterialPages()
          : _rubigoRouter.splashWidget.toMaterialPages(),
      //onDidRemovePage: _rubigoRouter.onDidRemovePage,
      onPopPage: _rubigoRouter.onPopPage,
    );
  }
}
