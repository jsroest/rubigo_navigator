// @dart=2.9

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_rubigo_navigator/pages/page_enum.dart';
import 'package:flutter_rubigo_navigator/pages/s200_quality_control/quality_control.dart';
import 'package:flutter_rubigo_navigator/pages/s200_quality_control/s210_perform_check/s210_perform_check_page.dart';
import 'package:flutter_rubigo_navigator/services/ws02_set_quality_control_item.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';

final s210PerformCheckControllerProvider =
    ChangeNotifierProvider<S210PerformCheckController>(
  (ref) {
    return S210PerformCheckController(
          () => S210PerformCheckPage(s210PerformCheckControllerProvider),
      ref.read(qualityControlProvider),
      ref.read(ws02SetQualityControlItemProvider),
    );
  },
);

class S210PerformCheckController extends RubigoController<Pages> {
  S210PerformCheckController(RubigoPage<Pages, RubigoController> Function() createRubigoPage,
      this.qualityControl,
      this.ws02setQualityControlItem)
      : super(createRubigoPage);

  final QualityControl qualityControl;
  final Ws02SetQualityControlItem ws02setQualityControlItem;

  Future<void> onQualityOkPressed() async {
    await ws02setQualityControlItem.set(qualityControl.selectedItem);
    qualityControl.remove(qualityControl.selectedItem);
    await rubigoNavigator.pop();
  }

  Future<void> onQualityNotOkPressed() async {
    await ws02setQualityControlItem.set(qualityControl.selectedItem);
    qualityControl.remove(qualityControl.selectedItem);
    await rubigoNavigator.pop();
  }
}
