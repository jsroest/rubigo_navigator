import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:rubigo_navigator/src/flutter/busy/rubigo_busy_event.dart';

class RubigoBusyService {
  int _busyCounter = 0;
  Timer? _timer;

  final notifier = ValueNotifier(
    const RubigoBusyEvent(
      isBusy: false,
      enabled: true,
      showProgressIndicator: false,
    ),
  );

  Future<T> busyWrapper<T>(Future<T> Function() function) async {
    try {
      _addBusy();
      return await function();
    } finally {
      _removeBusy();
    }
  }

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
