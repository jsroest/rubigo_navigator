import 'package:flutter/widgets.dart';

/// Adds easy access from a screen [Widget] to it's controller.
mixin RubigoScreenMixin<RUBIGO_CONTROLLER> {
  /// The controller that belongs to this screen
  late final RUBIGO_CONTROLLER controller;
}
