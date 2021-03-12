import 'dart:async';

import 'package:flutter_riverpod/all.dart';
import 'package:flutter_rubigo_navigator/pages/page_enum.dart';
import 'package:flutter_rubigo_navigator/pages/s020_quality_control/quality_control.dart';
import 'package:flutter_rubigo_navigator/pages/s020_quality_control/s020_select_item/s020_select_item_page.dart';
import 'package:flutter_rubigo_navigator/services/ws01_get_quality_control_items.dart';
import 'package:rubigo_navigator/rubigo.dart';

final s020ControllerProvider = ChangeNotifierProvider<S020Controller>(
  (ref) {
    return S020Controller(
      () => S020SelectItemPage(s020ControllerProvider),
      ref.read(qualityControlProvider),
      ref.read(ws01GetQualityControlItemsProvider),
    );
  },
);

class S020Controller extends RubigoController<Pages> {
  S020Controller(
    RubigoPage<Pages, RubigoController> Function() getRubigoPage,
    this.qualityControl,
    this.ws01getQualityControlItems,
  ) : super(getRubigoPage);

  final QualityControl qualityControl;
  final Ws01GetQualityControlItems ws01getQualityControlItems;

  @override
  FutureOr<void> onTop(StackChange stackChange, Pages previousPage) async {
    switch (stackChange) {
      case StackChange.pushed_on_top:
        var tmpItems = await ws01getQualityControlItems.get();
        if (tmpItems.isEmpty) {
          await rubigoNavigator.push(Pages.s050NoRowsFound);
          return;
        }
        qualityControl.items = tmpItems;
        break;
      case StackChange.returned_from_controller:
        if (qualityControl.items.isEmpty) {
          await rubigoNavigator.push(Pages.s040AllRowsDone);
          return;
        }
        break;
    }
    if (qualityControl.items.length == 1) {
      qualityControl.selectedItem = qualityControl.items.first;
      await rubigoNavigator.push(Pages.s030PerformCheck);
    }
  }

  @override
  FutureOr<bool> isPopping() => false;

  Future<void> onItemTap(int index) async {
    qualityControl.selectedItem = qualityControl.items[index];
    await rubigoNavigator.push(Pages.s030PerformCheck);
  }
}
