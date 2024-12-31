import 'package:flutter/material.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';
import 'package:rubigo_navigator/src/flutter/screen_to_page_converters.dart';

enum BackCallback {
  onDidRemovePage,
  onPopPage,
}

class RubigoRouterDelegate<SCREEN_ID extends Enum>
    extends RouterDelegate<SCREEN_ID>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  RubigoRouterDelegate({
    required this.rubigoRouter,
    required this.backCallback,
  }) {
    rubigoRouter.addListener(notifyListeners);
  }

  @override
  GlobalKey<NavigatorState>? get navigatorKey => GlobalKey();

  @override
  Future<void> setNewRoutePath(SCREEN_ID configuration) async {}

  final RubigoRouter<SCREEN_ID> rubigoRouter;
  final BackCallback backCallback;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      pages: rubigoRouter.isInitialized
          ? rubigoRouter.screens.toMaterialPages()
          : rubigoRouter.splashWidget.toMaterialPages(),
      onDidRemovePage: backCallback == BackCallback.onDidRemovePage
          ? rubigoRouter.onDidRemovePage
          : null,
      onPopPage: backCallback == BackCallback.onPopPage
          ? rubigoRouter.onPopPage
          : null,
    );
  }
}
