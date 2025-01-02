import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:rubigo_navigator/src/flutter/busy/rubigo_busy_event.dart';

class RubigoBusyService {
  int _busyCounter = 0;

  late final _delayer = _Delayer(
    () => notifier.value = notifier.value.copyWith(
      showProgressIndicator: notifier.value.isBusy,
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
      _delayer.run();
    }
  }

  void _removeBusy() {
    if (_busyCounter > 0) {
      _busyCounter--;
    }
    if (_busyCounter == 0) {
      notifier.value = notifier.value.copyWith(
        showProgressIndicator: false,
        isBusy: false,
      );
    }
  }

  final notifier = ValueNotifier(
    const RubigoBusyEvent(
      isBusy: false,
      enabled: true,
      showProgressIndicator: false,
    ),
  );
}

class _Delayer {
  _Delayer(this.action);

  final VoidCallback? action;
  Timer? _timer;

  void run() {
    // This will not work as intended if there are multiple calls within a short
    // period (< 300 ms).
    //TODO: make this perfect
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(const Duration(milliseconds: 300), action!);
  }
}
