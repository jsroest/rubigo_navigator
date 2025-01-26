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
    await rubigoRouter.ui.pop();
    return true;
  }
}
