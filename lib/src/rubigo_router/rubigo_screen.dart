import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rubigo_router/rubigo_router.dart';

/// A screen widget with a corresponding controller, which may implement a
/// [RubigoControllerMixin] (but doesn't have to). This set is uniquely
/// identified by a [SCREEN_ID].
@immutable
class RubigoScreen<SCREEN_ID extends Enum> {
  /// Creates a [RubigoScreen]
  RubigoScreen(
    this.screenId,
    this.screenWidget,
    this.getController,
  ) : pageKey = ValueKey(screenId);

  /// A unique key, based on the screenId. This key is used for [Page.key].
  final ValueKey<SCREEN_ID> pageKey;

  /// The enum for this [RubigoScreen]
  final SCREEN_ID screenId;

  /// The widget that represents this screen.
  final Widget screenWidget;

  /// Return the instance of the controller. You can use any dependency
  /// injection package in this function, as long as it always returns the same
  /// instance for the controller (singleton).
  final Object Function() getController;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RubigoScreen &&
        other.runtimeType == runtimeType &&
        other.screenId == screenId;
  }

  @override
  int get hashCode => screenId.hashCode;
}
