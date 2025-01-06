import 'package:flutter/material.dart';
import 'package:rubigo_navigator/src/flutter/screen_to_page_converters.dart';
import 'package:rubigo_navigator/src/rubigo_router.dart';
import 'package:rubigo_navigator/src/rubigo_screen.dart';

enum BackCallback {
  onDidRemovePage,
  onPopPage,
}

typedef RubigoScreenToPage = Page<void> Function(RubigoScreen screen);

class RubigoRouterDelegate<SCREEN_ID extends Enum>
    extends RouterDelegate<SCREEN_ID>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  RubigoRouterDelegate({
    required this.rubigoRouter,
    this.backCallback = BackCallback.onPopPage,
    this.observers,
    RubigoScreenToPage? widgetToPage,
  }) : widgetToPage = widgetToPage ??= ((e) => e.toMaterialPage()) {
    rubigoRouter.addListener(notifyListeners);
  }

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  @override
  Future<void> setNewRoutePath(SCREEN_ID configuration) async {}

  final RubigoRouter<SCREEN_ID> rubigoRouter;
  final BackCallback backCallback;
  final RubigoScreenToPage widgetToPage;
  final List<NavigatorObserver>? observers;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      observers: observers ?? const <NavigatorObserver>[],
      key: navigatorKey,
      pages: rubigoRouter.screens.map(widgetToPage).toList(),
      onDidRemovePage: backCallback == BackCallback.onDidRemovePage
          ? rubigoRouter.onDidRemovePage
          : null,
      onPopPage: backCallback == BackCallback.onPopPage
          ? rubigoRouter.onPopPage
          : null,
    );
  }
}
