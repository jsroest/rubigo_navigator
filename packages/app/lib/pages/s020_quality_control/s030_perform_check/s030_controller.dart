import 'package:flutter_riverpod/all.dart';
import 'package:flutter_rubigo_navigator/pages/page_enum.dart';
import 'package:flutter_rubigo_navigator/pages/s020_quality_control/quality_control.dart';
import 'package:flutter_rubigo_navigator/pages/s020_quality_control/s030_perform_check/s030_perform_check_page.dart';
import 'package:flutter_rubigo_navigator/services/ws02_set_quality_control_item.dart';
import 'package:rubigo_navigator/rubigo.dart';

final s030ControllerProvider = ChangeNotifierProvider<S030Controller>(
  (ref) {
    return S030Controller(
      () => S030PerformCheckPage(s030ControllerProvider),
      ref.read(qualityControlProvider),
      ref.read(ws02SetQualityControlItemProvider),
    );
  },
);

class S030Controller extends RubigoController<Pages> {
  S030Controller(RubigoPage<Pages, RubigoController> Function() getRubigoPage,
      this.qualityControl, this.ws02setQualityControlItem)
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
