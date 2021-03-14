import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_rubigo_navigator/pages/page_enum.dart';
import 'package:flutter_rubigo_navigator/pages/s200_quality_control/quality_control.dart';
import 'package:flutter_rubigo_navigator/pages/s200_quality_control/s200_select_item/s200_select_item_page.dart';
import 'package:flutter_rubigo_navigator/services/ws01_get_quality_control_items.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';

final s200SelectItemControllerProvider =
    ChangeNotifierProvider<S200SelectItemController>(
  (ref) {
    return S200SelectItemController(
      () => S200SelectItemPage(s200SelectItemControllerProvider),
      ref.read(qualityControlProvider),
      ref.read(ws01GetQualityControlItemsProvider),
    );
  },
);

class S200SelectItemController extends RubigoController<Pages> {
  S200SelectItemController(
    RubigoPage<Pages, RubigoController> Function() createRubigoPage,
    this.qualityControl,
    this.ws01getQualityControlItems,
  ) : super(createRubigoPage);

  final QualityControl qualityControl;
  final Ws01GetQualityControlItems ws01getQualityControlItems;

  @override
  FutureOr<void> onTop(StackChange stackChange, Pages previousPage) async {
    switch (stackChange) {
      case StackChange.pushed_on_top:
        var tmpItems = await ws01getQualityControlItems.get();
        if (tmpItems.isEmpty) {
          await rubigoNavigator.push(Pages.s230NoRowsFound);
          return;
        }
        qualityControl.items = tmpItems;
        break;
      case StackChange.returned_from_controller:
        if (qualityControl.items.isEmpty) {
          await rubigoNavigator.push(Pages.s220AllRowsDone);
          return;
        }
        break;
    }
    if (qualityControl.items.length == 1) {
      qualityControl.selectedItem = qualityControl.items.first;
      await rubigoNavigator.push(Pages.s210PerformCheck);
    }
  }

  @override
  FutureOr<bool> isPopping() => false;

  Future<void> onItemTap(int index) async {
    qualityControl.selectedItem = qualityControl.items[index];
    await rubigoNavigator.push(Pages.s210PerformCheck);
  }
}
