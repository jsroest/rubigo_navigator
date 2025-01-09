import 'package:flutter/material.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';

/// This class contains the data that the [RubigoBusyWidget] needs to rebuild
/// itself in the correct configuration.
@immutable
class RubigoBusyEvent {
  /// Create a new RubigoBusyEvent with the provided values.
  const RubigoBusyEvent({
    required this.enabled,
    required this.isBusy,
    required this.showProgressIndicator,
  });

  /// Is used to disable the [IgnorePointer], even when isBusy is true.
  /// This allows user interaction, for example for when showing a dialog when
  /// isBusy is true.
  final bool enabled;

  /// Is used to instantly disable any screen interaction.
  final bool isBusy;

  /// Is used to show a progress indicator, to let the user know the system is
  /// busy.
  final bool showProgressIndicator;

  /// Copy this [RubigoBusyEvent], with these values.
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
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RubigoBusyEvent &&
        other.runtimeType == runtimeType &&
        other.enabled == enabled &&
        other.isBusy == isBusy &&
        other.showProgressIndicator == showProgressIndicator;
  }

  @override
  int get hashCode => Object.hashAll([
        enabled,
        isBusy,
        showProgressIndicator,
      ]);
}
