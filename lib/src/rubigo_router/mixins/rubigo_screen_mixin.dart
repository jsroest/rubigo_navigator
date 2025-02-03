import 'package:flutter/widgets.dart';
import 'package:rubigo_router/rubigo_router.dart';

/// Adds easy access from a screen [Widget] to it's controller.
mixin RubigoScreenMixin<RUBIGO_CONTROLLER extends RubigoControllerMixin> {
  /// The controller that belongs to this screen
  late final RUBIGO_CONTROLLER controller;
}
