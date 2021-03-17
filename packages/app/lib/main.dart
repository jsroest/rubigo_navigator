import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_rubigo_navigator/pages/page_enum.dart';
import 'package:flutter_rubigo_navigator/pages/s100_main_menu/s100_main_menu_controller.dart';
import 'package:flutter_rubigo_navigator/pages/s200_quality_control/s200_select_item/s200_select_item_controller.dart';
import 'package:flutter_rubigo_navigator/pages/s200_quality_control/s210_perform_check/s210_perform_check_controller.dart';
import 'package:flutter_rubigo_navigator/pages/s200_quality_control/s220_all_rows_done/s220_all_rows_done_controller.dart';
import 'package:flutter_rubigo_navigator/pages/s200_quality_control/s230_no_rows_found/s230_no_rows_found_controller.dart';
import 'package:flutter_rubigo_navigator/pages/s900_settings/s900_settings_controller.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';

final appNavigatorProvider = ChangeNotifierProvider<RubigoNavigator<Pages>>(
  (ref) {
    return RubigoNavigator();
  },
);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ProviderScope(
      child: RubigoApp<Pages>(
        navigatorProvider: appNavigatorProvider,
        pages: (context) => {
          Pages.s100MainMenu: context.read(
            s100MainMenuControllerProvider,
          ),
          Pages.s200SelectItem: context.read(
            s200SelectItemControllerProvider,
          ),
          Pages.s210PerformCheck: context.read(
            s210PerformCheckControllerProvider,
          ),
          Pages.s220AllRowsDone: context.read(
            s220AllRowsDoneControllerProvider,
          ),
          Pages.s230NoRowsFound: context.read(
            s230NoRowsFoundControllerProvider,
          ),
          Pages.s900Settings: context.read(
            s900SettingsControllerProvider,
          ),
        },
      ),
    ),
  );
}
