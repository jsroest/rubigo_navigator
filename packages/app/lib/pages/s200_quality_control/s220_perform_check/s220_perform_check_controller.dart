import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_rubigo_navigator/pages/page_enum.dart';
import 'package:flutter_rubigo_navigator/pages/s200_quality_control/quality_control.dart';
import 'package:flutter_rubigo_navigator/pages/s200_quality_control/s220_perform_check/s220_perform_check_page.dart';
import 'package:flutter_rubigo_navigator/services/ws02_set_quality_control_item.dart';
import 'package:rubigo_navigator/rubigo.dart';

final s220PerformCheckControllerProvider =
    ChangeNotifierProvider<S220PerformCheckController>(
  (ref) {
    return S220PerformCheckController(
      () => S220PerformCheckPage(s220PerformCheckControllerProvider),
      ref.read(qualityControlProvider),
      ref.read(ws02SetQualityControlItemProvider),
    );
  },
);

class S220PerformCheckController extends RubigoController<Pages> {
  S220PerformCheckController(
      RubigoPage<Pages, RubigoController> Function() getRubigoPage,
      this.qualityControl,
      this.ws02setQualityControlItem)
      : super(getRubigoPage);

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
