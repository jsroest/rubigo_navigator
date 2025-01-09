import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rubigo_navigator/src/rubigo_controller.dart';

/// A unique screenId is bundled to a screenWidget and a controller-getter
class RubigoScreen<SCREEN_ID extends Enum> {
  /// Creates a RubigoScreen
  RubigoScreen(
    this.screenId,
    this.screenWidget,
    this.getController,
  ) : pageKey = ValueKey(screenId);

  /// A unique pageKey, based on the screenId. This key is normally passed to
  /// the constructor of the [MaterialPage] or [CupertinoPage] as the key
  /// parameter.
  final ValueKey<SCREEN_ID> pageKey;

  /// The unique identifier for this [RubigoScreen]
  final SCREEN_ID screenId;

  /// The widget that represents this screen. By default this widget is wrapped
  /// in a [MaterialPage], but you can pass your own widgetToPage  function in
  /// the widgetToPage parameter in the [RouterDelegate] constructor.
  final Widget screenWidget;

  /// Return the instance of the controller. You can use any dependency
  /// injection package in this function, as long as it always returns the same
  /// instance for the controller (singleton).
  final RubigoController<SCREEN_ID> Function() getController;
}
