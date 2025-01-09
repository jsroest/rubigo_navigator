import 'package:rubigo_navigator/rubigo_navigator.dart';

/// Apply this mixin for easy access to the corresponding controller.
/// This is wired up during [RubigoRouter.init] for each [RubigoScreen] in the
/// list of [RubigoRouter.availableScreens]
mixin RubigoScreenMixin<RUBIGO_CONTROLLER extends RubigoController> {
  /// The controller that belongs to this screen
  late final RUBIGO_CONTROLLER controller;
}
