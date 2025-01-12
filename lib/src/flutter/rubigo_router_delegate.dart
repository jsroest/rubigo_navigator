import 'package:flutter/widgets.dart';
import 'package:rubigo_router/rubigo_router.dart';

/// Use [Navigator.onDidRemovePage], or the deprecated [Navigator.onPopPage].
enum BackCallback {
  /// [Navigator.onDidRemovePage] -> New, but with some issues [See](https://github.com/flutter/flutter/issues/160463).
  onDidRemovePage,

  //ignore:deprecated_member_use
  /// [Navigator.onPopPage] => Works, but deprecated
  onPopPage,
}

/// Use this class to wrap a [RubigoRouter] or use it as a blue-print for your
/// own [RouterDelegate].
class RubigoRouterDelegate<SCREEN_ID extends Enum>
    extends RouterDelegate<SCREEN_ID>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  /// Creates a [RubigoRouterDelegate]
  RubigoRouterDelegate({
    required this.rubigoRouter,
    this.backCallback = BackCallback.onPopPage,
    this.observers,
    Page<void> Function(RubigoScreen screen)? rubigoScreenToPage,
  }) : rubigoScreenToPage = rubigoScreenToPage ??= ((e) => e.toMaterialPage()) {
    rubigoRouter.addListener(notifyListeners);
  }

  @override
  GlobalKey<NavigatorState> get navigatorKey => rubigoRouter.navigatorKey;

  // coverage:ignore-start
  @override
  Future<void> setNewRoutePath(SCREEN_ID configuration) async {}

  // coverage:ignore-end

  /// The [RubigoRouter] that is in this instance.
  final RubigoRouter<SCREEN_ID> rubigoRouter;

  /// The [BackCallback] system that this delegate uses.
  final BackCallback backCallback;

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
      pages: rubigoRouter.screens.map(rubigoScreenToPage).toList(),
      onDidRemovePage: backCallback == BackCallback.onDidRemovePage
          ? rubigoRouter.onDidRemovePage
          : null,
      onPopPage: backCallback == BackCallback.onPopPage
          ? rubigoRouter.onPopPage
          : null,
    );
  }
}
