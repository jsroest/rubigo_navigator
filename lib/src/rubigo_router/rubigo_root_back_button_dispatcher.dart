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
    if (currentRouteIsPage(rubigoRouter)) {
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
}
