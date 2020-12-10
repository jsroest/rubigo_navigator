import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_rubigo_navigator/classes/material_page_ex.dart';
import 'package:flutter_rubigo_navigator/navigator/rubigo_navigator.dart';
import 'package:flutter_rubigo_navigator/navigator/rubigo_page_controller.dart';
import 'package:flutter_rubigo_navigator/pages/s010_login/s010_login.page.dart';
import 'package:flutter_rubigo_navigator/pages/s020_main_menu/s020_controller.dart';

final s010ControllerProvider = ChangeNotifierProvider<S010Controller>(
  (ref) {
    return S010Controller(
      S010LoginPage.page,
      ref.read(rubigoNavigatorProvider),
    );
  },
);

class S010Controller extends RubigoPageController {
  S010Controller(
    MaterialPageEx page,
    RubigoNavigator rubigoNavigator,
  ) : super(page, rubigoNavigator);

  void doContinue() {
    rubigoNavigator.push(S020Controller);
  }
}
