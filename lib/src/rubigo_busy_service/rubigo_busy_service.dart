import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:rubigo_router/rubigo_router.dart';
import 'package:rubigo_router/src/rubigo_busy_service/rubigo_busy_event.dart';

/// This service is used to keep track if the application is busy.
class RubigoBusyService {
  int _busyCounter = 0;
  Timer? _timer;

  /// This notifier has the current value of the busy values represented by a
  /// [RubigoBusyEvent] and will inform it's listeners when the value changes.
  final notifier = ValueNotifier(
    const RubigoBusyEvent(
      isBusy: false,
      enabled: true,
      showProgressIndicator: false,
    ),
  );

  /// Prevent user interaction during long lasting calls by wrapping these calls
  /// with this wrapper. This function can be called recursively. The UI is
  /// blocked immediately with a [IgnorePointer]. After 300ms a progress
  /// indicator shown.
  Future<T> busyWrapper<T>(Future<T> Function() function) async {
    try {
      _addBusy();
      return await function();
    } finally {
      _removeBusy();
    }
  }

  /// A shortcut to get the current value of isBusy from the notifier.
  bool get isBusy => notifier.value.isBusy;

  /// A shortcut to get the current value of enabled from the notifier.
  bool get enabled => notifier.value.enabled;

  /// Temporarily disable the [IgnorePointer] in the [RubigoBusyWidget] by
  /// setting the value to false. When done, set the value back to true.
  set enabled(bool value) =>
      notifier.value = notifier.value.copyWith(enabled: value);

  void _addBusy() {
    _busyCounter++;
    notifier.value = notifier.value.copyWith(
      isBusy: true,
    );
    if (_busyCounter == 1) {
      _timer ??= _setTimer();
    }
  }

  void _removeBusy() {
    if (_busyCounter > 0) {
      _busyCounter--;
    }
    if (_busyCounter == 0) {
      _cancelTimer();
      notifier.value = notifier.value.copyWith(
        showProgressIndicator: false,
        isBusy: false,
      );
    }
  }

  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  Timer _setTimer() {
    return Timer(
      const Duration(milliseconds: 300),
      () {
        _timer = null;
        notifier.value = notifier.value.copyWith(
          // Instead of setting the value to true, set the value to the current
          // value of isBusy. This is to prevent edge cases where the app might
          // stay unresponsive due to an unforeseen race condition.
          showProgressIndicator: notifier.value.isBusy,
        );
      },
    );
  }
}
