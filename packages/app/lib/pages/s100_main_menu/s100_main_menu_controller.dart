import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_rubigo_navigator/pages/page_enum.dart';
import 'package:flutter_rubigo_navigator/pages/s100_main_menu/s100_main_menu_page.dart';
import 'package:flutter_rubigo_navigator/services/ws01_get_quality_control_items.dart';
import 'package:rubigo_navigator/rubigo.dart';

final s100MainMenuControllerProvider =
    ChangeNotifierProvider<S100MainMenuController>(
  (ref) {
    return S100MainMenuController(
      () => S100MainMenuPage(s100MainMenuControllerProvider),
    );
  },
);

class S100MainMenuController extends RubigoController<Pages> {
  S100MainMenuController(
      RubigoPage<Pages, RubigoController> Function() getRubigoPage)
      : super(getRubigoPage);

  Future<void> onQualityControlTap() async {
    await showDialog<void>(
      context: rubigoNavigator.navigatorState.currentContext,
      builder: (context) {
        var ws01 = context.read(ws01GetQualityControlItemsProvider);
        return AlertDialog(
          title: Text('Amount to check (debug)'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  ws01.debugAmount = DebugAmount.empty;
                  Navigator.of(context).pop();
                },
                child: Text('No items'),
              ),
              ElevatedButton(
                onPressed: () {
                  ws01.debugAmount = DebugAmount.one;
                  Navigator.of(context).pop();
                },
                child: Text('One item'),
              ),
              ElevatedButton(
                onPressed: () {
                  ws01.debugAmount = DebugAmount.all;
                  Navigator.of(context).pop();
                },
                child: Text('Three items'),
              )
            ],
          ),
        );
      },
    );
    await rubigoNavigator.push(Pages.s210SelectItem);
  }

  void onSettingsTap() {
    rubigoNavigator.push(Pages.s900Settings);
  }
}
