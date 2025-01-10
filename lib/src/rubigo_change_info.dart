import 'package:flutter/foundation.dart';

enum EventType {
  push,
  pop,
  popTo,
  replaceStack,
}

@immutable
class RubigoChangeInfo<SCREEN_ID extends Enum> {
  const RubigoChangeInfo(
    this.eventType,
    this.previousScreen,
    this.screenStack,
  );

  final EventType eventType;
  final SCREEN_ID? previousScreen;
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
