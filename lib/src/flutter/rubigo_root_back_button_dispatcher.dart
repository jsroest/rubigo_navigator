import 'package:flutter/widgets.dart';
import 'package:rubigo_router/rubigo_router.dart';

/// This class extends [RootBackButtonDispatcher] and delegates hardware back
/// button presses to the [RubigoRouter.handleBackEvent].
class RubigoRootBackButtonDispatcher extends RootBackButtonDispatcher {
  /// Creates a RubigoRootBackButtonDispatcher
  RubigoRootBackButtonDispatcher(this.rubigoRouter);

  /// The [RubigoRouter] to delegate the calls to.
  final RubigoRouter rubigoRouter;

  @override
  Future<bool> didPopRoute() async {
    final screenId = rubigoRouter.screens.value.last.screenId;
    await rubigoRouter.handleBackEvent(screenId);
    return true;
  }
}
