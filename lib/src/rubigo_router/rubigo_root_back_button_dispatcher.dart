import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:rubigo_router/rubigo_router.dart';

/// This class extends [RootBackButtonDispatcher] and delegates hardware back
/// button presses to the [RubigoRouter.ui].pop function or to
/// [RootBackButtonDispatcher.didPopRoute] when appropriate.
class RubigoRootBackButtonDispatcher extends RootBackButtonDispatcher {
  /// Creates a [RubigoRootBackButtonDispatcher]
  RubigoRootBackButtonDispatcher(this.rubigoRouter);

  /// The [RubigoRouter] to delegate the calls to.
  final RubigoRouter rubigoRouter;

  @override
  Future<bool> didPopRoute() async {
    await rubigoRouter
        .logNavigation('RubigoRootBackButtonDispatcher.didPopRoute() called.');

    if (currentRouteIsPage(rubigoRouter)) {
      await rubigoRouter.logNavigation('Current route is Page().');
      await rubigoRouter.ui.pop();
      return true;
    }
    // This is for the default behaviour. For example to close a dialog when
    // the user presses the Android hardware back button.
    await rubigoRouter.logNavigation(
      'Current route is a pageless route. super.didPopRoute() called.',
    );
    await super.didPopRoute();
    return true;
  }
}
