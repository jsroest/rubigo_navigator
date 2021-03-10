import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:flutter_rubigo_navigator/pages/page_enum.dart';
import 'package:flutter_rubigo_navigator/pages/s010_login/s010_controller.dart';
import 'package:flutter_rubigo_navigator/pages/s020_main_menu/s020_controller.dart';
import 'package:flutter_rubigo_navigator/pages/s030_sub_page/s030_controller.dart';
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
          Pages.S010: context.read(s010ControllerProvider),
          Pages.S020: context.read(s020ControllerProvider),
          Pages.S030: context.read(s030ControllerProvider),
        },
      ),
    ),
  );
}
