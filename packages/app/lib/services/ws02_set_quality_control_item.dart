import 'package:flutter_riverpod/all.dart';
import 'package:flutter_rubigo_navigator/services/ws01_get_quality_control_items.dart';

final ws02SetQualityControlItemProvider = Provider<Ws02SetQualityControlItem>(
  (ref) {
    return Ws02SetQualityControlItem();
  },
);

class Ws02SetQualityControlItem {
  Future<void> set(QualityControlItem item) async {
    await Future<void>.delayed(Duration(seconds: 1));
    return;
  }
}
