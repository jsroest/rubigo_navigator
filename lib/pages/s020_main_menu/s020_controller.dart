import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_rubigo_navigator/app.dart';
import 'package:flutter_rubigo_navigator/navigator/rubigo_controller.dart';
import 'package:flutter_rubigo_navigator/navigator/rubigo_material_page.dart';
import 'package:flutter_rubigo_navigator/navigator/rubigo_navigator.dart';
import 'package:flutter_rubigo_navigator/navigator/rubigo_stack_manager.dart';
import 'package:flutter_rubigo_navigator/pages/page_enum.dart';
import 'package:flutter_rubigo_navigator/pages/s020_main_menu/s020_main_menu_page.dart';

final s020ControllerProvider = ChangeNotifierProvider<S020Controller>(
  (ref) {
    return S020Controller(
      S020MainMenuPage.page,
      ref.read(rubigoNavigatorProvider),
    );
  },
);

class S020Controller extends RubigoController<Pages> {
  S020Controller(
    RubigoMaterialPage page,
    RubigoNavigator<Pages> rubigoNavigator,
  ) : super(page, rubigoNavigator);

  @override
  FutureOr<void> onTop(
    StackChange stackChange,
    RubigoController previousController,
  ) {
    if (stackChange == StackChange.pushed_on_top) {
      rubigoNavigator.push(Pages.S030);
    }
  }

  @override
  FutureOr<void> isShown() {}

  void doContinue() {
    rubigoNavigator.push(Pages.S030);
  }
}
