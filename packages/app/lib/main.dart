import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:flutter_rubigo_navigator/pages/page_enum.dart';
import 'package:flutter_rubigo_navigator/pages/s010_main_menu/s010_controller.dart';
import 'package:flutter_rubigo_navigator/pages/s020_quality_control/s020_select_item/s020_controller.dart';
import 'package:flutter_rubigo_navigator/pages/s020_quality_control/s030_perform_check/s030_controller.dart';
import 'package:flutter_rubigo_navigator/pages/s020_quality_control/s040_all_rows_done/s040_controller.dart';
import 'package:flutter_rubigo_navigator/pages/s020_quality_control/s050_no_rows_found/s050_controller.dart';
import 'package:flutter_rubigo_navigator/pages/s999_settings/s999_controller.dart';
import 'package:rubigo_navigator/rubigo.dart';
import 'package:rubigo_navigator/rubigo_app.dart';

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
          Pages.s010MainMenu: context.read(s010ControllerProvider),
          Pages.s020SelectItem: context.read(s020ControllerProvider),
          Pages.s030PerformCheck: context.read(s030ControllerProvider),
          Pages.s040AllRowsDone: context.read(s040ControllerProvider),
          Pages.s050NoRowsFound: context.read(s050ControllerProvider),
          Pages.s999Settings: context.read(s999ControllerProvider),
        },
      ),
    ),
  );
}
