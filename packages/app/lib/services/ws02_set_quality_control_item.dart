// @dart=2.9

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_rubigo_navigator/services/ws01_get_quality_control_items.dart';
import 'package:rubigo_navigator/services/rubigo_busy_service.dart';

final ws02SetQualityControlItemProvider = Provider<Ws02SetQualityControlItem>(
  (ref) {
    return Ws02SetQualityControlItem(
      ref.read(busyServiceProvider),
    );
  },
);

class Ws02SetQualityControlItem {
  Ws02SetQualityControlItem(this.busyService);

  final BusyService busyService;

  Future<void> set(QualityControlItem item) async {
    await busyService.protect(
          () async {
        await Future<void>.delayed(Duration(seconds: 1));
      },
    );
    return;
  }
}
