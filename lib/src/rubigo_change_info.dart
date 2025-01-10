import 'package:flutter/foundation.dart';

/// The cause of this navigation event
enum EventType {
  /// This screen is on-top because of a push
  push,

  /// This screen is on-top because of a pop
  pop,

  /// This screen is on-top because of a popTo
  popTo,

  /// This screen is on-top because of a replaceStack
  replaceStack,
}

/// This class contains information about the navigation event class RubigoChangeInfo<SCREEN_ID extends Enum> {
@immutable
class RubigoChangeInfo<SCREEN_ID extends Enum> {
  /// Creates a RubigoChangeInfo
  const RubigoChangeInfo(
    this.eventType,
    this.previousScreen,
    this.screenStack,
  );

  /// The reason why this screen is on-top.
  final EventType eventType;

  /// The screen that was navigated from.
  final SCREEN_ID? previousScreen;

  /// The current screenStack.
  final List<SCREEN_ID> screenStack;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RubigoChangeInfo<SCREEN_ID> &&
        runtimeType == other.runtimeType &&
        eventType == other.eventType &&
        previousScreen == other.previousScreen &&
        listEquals(screenStack, other.screenStack);
  }

  @override
  int get hashCode =>
      eventType.hashCode ^
      (previousScreen?.hashCode ?? 0) ^
      Object.hashAll(screenStack);
}
