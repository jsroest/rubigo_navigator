import 'package:flutter_test/flutter_test.dart';
import 'package:rubigo_navigator/src/flutter/busy/rubigo_busy_event.dart';

void main() {
  test(
    'test rubigo_busy_event',
    () {
      final hashHistory = <int>[];
      for (var counter = 0; counter < 8; counter++) {
        final binaryString = counter.toRadixString(2).padLeft(3, '0');
        final enabled = binaryString[0] == '1';
        final isBusy = binaryString[1] == '1';
        final showProgressIndicator = binaryString[2] == '1';
        final busyEvent1 = RubigoBusyEvent(
          enabled: enabled,
          isBusy: isBusy,
          showProgressIndicator: showProgressIndicator,
        );
        final busyEvent2 = RubigoBusyEvent(
          enabled: enabled,
          isBusy: isBusy,
          showProgressIndicator: showProgressIndicator,
        );
        expect(busyEvent1, busyEvent2);
        final busyEvent3 = busyEvent2.copyWith(enabled: !busyEvent2.enabled);
        expect(busyEvent2, isNot(busyEvent3));
        expect(busyEvent3, busyEvent3);
        expect(hashHistory.contains(busyEvent1.hashCode), false);
        expect(busyEvent1.hashCode, busyEvent2.hashCode);
        hashHistory.add(busyEvent1.hashCode);
      }
    },
  );
}
