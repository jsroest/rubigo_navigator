import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:rubigo_router/rubigo_router.dart';

/// This class extends [RootBackButtonDispatcher] and delegates hardware back
/// button presses to the [RubigoRouter]'s ui pop functions..
class RubigoRootBackButtonDispatcher extends RootBackButtonDispatcher {
  /// Creates a RubigoRootBackButtonDispatcher
  RubigoRootBackButtonDispatcher(this.rubigoRouter);

  /// The [RubigoRouter] to delegate the calls to.
  final RubigoRouter rubigoRouter;

  @override
  Future<bool> didPopRoute() async {
    unawaited(rubigoRouter.logNavigation('didPopRoute() called.'));
    if (_currentRouteIsPage()) {
      unawaited(rubigoRouter.logNavigation('Detected a page.'));
      await rubigoRouter.ui.pop();
      return true;
    }
    // This is for the default behaviour. For example to close a dialog when
    // the user presses the Android hardware back button.
    unawaited(
      rubigoRouter.logNavigation(
        'Detected a pageless route.\nsuper.didPopRoute() called.',
      ),
    );

    await super.didPopRoute();
    return true;
  }

  bool _currentRouteIsPage() {
    var isPage = false;
    final context = rubigoRouter.navigatorKey.currentContext;
    if (context == null) {
      return false;
    }
    // https://stackoverflow.com/questions/50817086/how-to-check-which-the-current-route-is
    Navigator.of(context).popUntil(
      (route) {
        if (route.settings is Page) {
          isPage = true;
        }
        return true;
      },
    );
    return isPage;
  }
}
