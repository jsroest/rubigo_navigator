import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:rubigo_router/rubigo_router.dart';

/// Use this class to wrap a [RubigoRouter] or use it as a blue-print for your
/// own [RouterDelegate].
class RubigoRouterDelegate<SCREEN_ID extends Enum>
    extends RouterDelegate<SCREEN_ID>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  /// Creates a [RubigoRouterDelegate]
  RubigoRouterDelegate({
    required this.rubigoRouter,
    this.observers,
    Page<void> Function(RubigoScreen screen)? rubigoScreenToPage,
    this.onPopPage,
    this.onDidRemovePage,
  }) : rubigoScreenToPage = rubigoScreenToPage ??= ((e) => e.toMaterialPage()) {
    rubigoRouter.addListener(notifyListeners);
  }

  @override
  GlobalKey<NavigatorState> get navigatorKey => rubigoRouter.navigatorKey;

  // coverage:ignore-start
  @override
  Future<void> setNewRoutePath(SCREEN_ID configuration) async {}

  // coverage:ignore-end
  /// See [defaultOnDidRemovePage]
  final PopPageCallback? onPopPage;

  /// See [defaultOnDidRemovePage]
  final DidRemovePageCallback? onDidRemovePage;

  /// A default implementation for [Navigator.onDidRemovePage], because
  //ignore: deprecated_member_use
  /// [Navigator] requires an implementation for [Navigator.onPopPage] or an
  /// implementation for [Navigator.onDidRemovePage]. Because of issues with
  /// the current implementation of [Navigator], we rely on the pages to have
  /// a [RubigoControllerPopScope] or [RubigoRouterPopScope], which is a
  /// descendant of [PopScope]
  /// The [defaultOnDidRemovePage] only logs the calls and exists to satisfy
  /// asserts.
  void defaultOnDidRemovePage(Page<Object?> page) {
    final pageKey = page.key;
    if (pageKey == null || pageKey is! ValueKey<SCREEN_ID>) {
      throw UnsupportedError(
        'PANIC: page.key must be of type ValueKey<$SCREEN_ID>.',
      );
    }
    final removedScreenId = pageKey.value;
    unawaited(
      rubigoRouter.logNavigation(
        'onDidRemovePage(${removedScreenId.name}) -ignoring',
      ),
    );
  }

  /// The [RubigoRouter] that is in this instance.
  final RubigoRouter<SCREEN_ID> rubigoRouter;

  /// This function converts a [RubigoScreen] to a [Page]. The default
  /// implementation uses [ExtensionOnRubigoScreen.toMaterialPage].
  final Page<void> Function(RubigoScreen screen) rubigoScreenToPage;

  /// The list of [NavigatorObserver] passed to the [Navigator]. Added for
  /// testing purposes, but may have other use cases.
  final List<NavigatorObserver>? observers;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      observers: observers ?? const <NavigatorObserver>[],
      key: navigatorKey,
      pages: rubigoRouter.screens.value.map(rubigoScreenToPage).toList(),
      onDidRemovePage: (onDidRemovePage == null && onPopPage == null)
          ? defaultOnDidRemovePage
          : onDidRemovePage,
      //ignore: deprecated_member_use
      onPopPage: onPopPage,
    );
  }
}
