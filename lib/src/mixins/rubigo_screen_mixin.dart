import 'package:rubigo_router/rubigo_router.dart';

/// Adds easy access to the corresponding controller.
mixin RubigoScreenMixin<RUBIGO_CONTROLLER extends RubigoControllerMixin> {
  /// The controller that belongs to this screen
  late final RUBIGO_CONTROLLER controller;
}
