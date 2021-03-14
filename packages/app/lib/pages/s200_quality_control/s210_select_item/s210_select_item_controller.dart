import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_rubigo_navigator/pages/page_enum.dart';
import 'package:flutter_rubigo_navigator/pages/s200_quality_control/quality_control.dart';
import 'package:flutter_rubigo_navigator/pages/s200_quality_control/s210_select_item/s210_select_item_page.dart';
import 'package:flutter_rubigo_navigator/services/ws01_get_quality_control_items.dart';
import 'package:rubigo_navigator/rubigo.dart';

final s210SelectItemControllerProvider =
    ChangeNotifierProvider<S210SelectItemController>(
  (ref) {
    return S210SelectItemController(
      () => S210SelectItemPage(s210SelectItemControllerProvider),
      ref.read(qualityControlProvider),
      ref.read(ws01GetQualityControlItemsProvider),
    );
  },
);

class S210SelectItemController extends RubigoController<Pages> {
  S210SelectItemController(
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
          await rubigoNavigator.push(Pages.s240NoRowsFound);
          return;
        }
        qualityControl.items = tmpItems;
        break;
      case StackChange.returned_from_controller:
        if (qualityControl.items.isEmpty) {
          await rubigoNavigator.push(Pages.s230AllRowsDone);
          return;
        }
        break;
    }
    if (qualityControl.items.length == 1) {
      qualityControl.selectedItem = qualityControl.items.first;
      await rubigoNavigator.push(Pages.s220PerformCheck);
    }
  }

  @override
  FutureOr<bool> isPopping() => false;

  Future<void> onItemTap(int index) async {
    qualityControl.selectedItem = qualityControl.items[index];
    await rubigoNavigator.push(Pages.s220PerformCheck);
  }
}
