import 'package:flutter/foundation.dart';

@immutable
class RubigoBusyEvent {
  const RubigoBusyEvent({
    required this.enabled,
    required this.isBusy,
    required this.showProgressIndicator,
  });

  final bool enabled;
  final bool isBusy;
  final bool showProgressIndicator;

  RubigoBusyEvent copyWith({
    bool? enabled,
    bool? isBusy,
    bool? showProgressIndicator,
  }) {
    return RubigoBusyEvent(
      enabled: enabled ?? this.enabled,
      isBusy: isBusy ?? this.isBusy,
      showProgressIndicator:
          showProgressIndicator ?? this.showProgressIndicator,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is RubigoBusyEvent &&
      other.runtimeType == runtimeType &&
      other.enabled == enabled &&
      other.isBusy == isBusy &&
      other.showProgressIndicator == showProgressIndicator;

  @override
  int get hashCode => Object.hashAll([
        enabled,
        isBusy,
        showProgressIndicator,
      ]);
}
