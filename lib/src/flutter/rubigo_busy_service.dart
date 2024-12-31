import 'dart:async';

import 'package:flutter/foundation.dart';

class RubigoBusyService extends ChangeNotifier {
  int _busyCounter = 0;

  late final _deBouncer =
      _DeBouncer(() => _showProgressIndicatorSetter(isBusy));

  Future<T> protectWrapper<T>(Future<T> Function() function) async {
    try {
      _addBusy();
      return await function();
    } finally {
      _removeBusy();
    }
  }

  void _addBusy() {
    _busyCounter++;
    notifyListeners();
    if (_busyCounter == 1) {
      _deBouncer.run();
    }
  }

  void _removeBusy() {
    if (_busyCounter > 0) {
      _busyCounter--;
      if (_busyCounter == 0) {
        _showProgressIndicatorSetter(false);
      }
      notifyListeners();
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

  bool get showProgressIndicator => _showProgressIndicator;

  void _showProgressIndicatorSetter(bool value) {
    if (_showProgressIndicator == value) {
      return;
    }
    _showProgressIndicator = value;
    notifyListeners();
  }
}

class _DeBouncer {
  _DeBouncer(this.action);

  final VoidCallback? action;
  Timer? _timer;

  void run() {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(const Duration(milliseconds: 300), action!);
  }
}
