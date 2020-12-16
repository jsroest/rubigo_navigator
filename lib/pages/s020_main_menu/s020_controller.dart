import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_rubigo_navigator/classes/material_page_ex.dart';
import 'package:flutter_rubigo_navigator/navigator/controller.dart';
import 'package:flutter_rubigo_navigator/navigator/rubigo_navigator.dart';
import 'package:flutter_rubigo_navigator/navigator/rubigo_stack_manager.dart';
import 'package:flutter_rubigo_navigator/pages/s020_main_menu/s020_main_menu_page.dart';
import 'package:flutter_rubigo_navigator/pages/s030_sub_page/s030_controller.dart';

final s020ControllerProvider = ChangeNotifierProvider<S020Controller>(
  (ref) {
    return S020Controller(
      S020MainMenuPage.page,
      ref.read(rubigoNavigatorProvider),
      's020',
    );
  },
);

class S020Controller extends Controller {
  S020Controller(
      MaterialPageEx page, RubigoNavigator rubigoNavigator, String id)
      : super(page, rubigoNavigator, id);

  @override
  FutureOr<void> onTop(
    StackChange stackChange,
    Controller previousController,
  ) {
    super.onTop(stackChange, previousController);
    if (stackChange == StackChange.pushed_on_top) {
      rubigoNavigator.push(S030Controller);
    }
  }

  void doContinue() {
    rubigoNavigator.push(S030Controller);
  }
}
