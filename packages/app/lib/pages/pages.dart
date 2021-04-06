import 'package:flutter_rubigo_navigator/pages/s100_main_menu/s100_main_menu_controller.dart';
import 'package:flutter_rubigo_navigator/pages/s200_quality_control/s200_select_item/s200_select_item_controller.dart';
import 'package:flutter_rubigo_navigator/pages/s200_quality_control/s210_perform_check/s210_perform_check_controller.dart';
import 'package:flutter_rubigo_navigator/pages/s200_quality_control/s220_all_rows_done/s220_all_rows_done_controller.dart';
import 'package:flutter_rubigo_navigator/pages/s200_quality_control/s230_no_rows_found/s230_no_rows_found_controller.dart';
import 'package:flutter_rubigo_navigator/pages/s900_settings/s900_settings_controller.dart';

enum Pages {
  s100MainMenu,
  s200SelectItem,
  s210PerformCheck,
  s220AllRowsDone,
  s230NoRowsFound,
  s900Settings,
}

final controllers = {
  Pages.s100MainMenu: s100MainMenuControllerProvider,
  Pages.s200SelectItem: s200SelectItemControllerProvider,
  Pages.s210PerformCheck: s210PerformCheckControllerProvider,
  Pages.s220AllRowsDone: s220AllRowsDoneControllerProvider,
  Pages.s230NoRowsFound: s230NoRowsFoundControllerProvider,
  Pages.s900Settings: s900SettingsControllerProvider,
};
