import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_rubigo_navigator/pages/page_enum.dart';
import 'package:flutter_rubigo_navigator/pages/s100_main_menu/s100_main_menu_controller.dart';
import 'package:flutter_rubigo_navigator/pages/s200_quality_control/s210_select_item/s210_select_item_controller.dart';
import 'package:flutter_rubigo_navigator/pages/s200_quality_control/s220_perform_check/s220_perform_check_controller.dart';
import 'package:flutter_rubigo_navigator/pages/s200_quality_control/s230_all_rows_done/s230_all_rows_done_controller.dart';
import 'package:flutter_rubigo_navigator/pages/s200_quality_control/s240_no_rows_found/s240_no_rows_found_controller.dart';
import 'package:flutter_rubigo_navigator/pages/s900_settings/s900_settings_controller.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';

final appNavigatorProvider = ChangeNotifierProvider<RubigoNavigator<Pages>>(
  (ref) {
    return RubigoNavigator();
  },
);

void main() {
  runApp(
    ProviderScope(
      child: RubigoApp<Pages>(
        navigatorProvider: appNavigatorProvider,
        pages: (context) => {
          Pages.s100MainMenu: context.read(
            s100MainMenuControllerProvider,
          ),
          Pages.s210SelectItem: context.read(
            s210SelectItemControllerProvider,
          ),
          Pages.s220PerformCheck: context.read(
            s220PerformCheckControllerProvider,
          ),
          Pages.s230AllRowsDone: context.read(
            s230AllRowsDoneControllerProvider,
          ),
          Pages.s240NoRowsFound: context.read(
            s240NoRowsFoundControllerProvider,
          ),
          Pages.s900Settings: context.read(
            s900SettingsControllerProvider,
          ),
        },
      ),
    ),
  );
}
