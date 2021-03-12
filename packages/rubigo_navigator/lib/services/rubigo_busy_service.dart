import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final busyServiceProvider = ChangeNotifierProvider<BusyService>(
  (ref) {
    return BusyService();
  },
);

class BusyService extends ChangeNotifier {
  BusyService() {
    _progressIndicatorDeBouncer = DeBouncer(
      action: () => _showProgressIndicatorSetter = isBusy,
    );
  }

  int _busyCounter = 0;
  DeBouncer _progressIndicatorDeBouncer;

  void _addBusy() {
    _busyCounter++;
    notifyListeners();
    if (_busyCounter == 1) {
      _progressIndicatorDeBouncer.run();
    }
  }

  void _removeBusy() {
    if (_busyCounter > 0) {
      _busyCounter--;
      if (_busyCounter == 0) {
        _showProgressIndicatorSetter = false;
      }
      notifyListeners();
    }
  }

  Future<void> protect(Future<void> Function() function) async {
    if (isBusy) {
      return;
    }
    try {
      _addBusy();
      await function();
    } finally {
      _removeBusy();
    }
  }

  bool get isBusy => _busyCounter > 0;

  bool _enabled = true;

  bool get enabled => _enabled;

  set enabled(bool value) {
    if (_enabled != value) {
      _enabled = value;
      notifyListeners();
    }
  }

  bool _showProgressIndicator = false;

  bool get showProgressIndicator {
    return _showProgressIndicator;
  }

  set _showProgressIndicatorSetter(bool value) {
    if (_showProgressIndicator != value) {
      _showProgressIndicator = value;
      notifyListeners();
    }
  }
}

class DeBouncer {
  DeBouncer({
    this.milliseconds = 300,
    this.action,
  });

  final int milliseconds;
  final VoidCallback action;
  Timer _timer;

  void run() {
    if (_timer != null) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
