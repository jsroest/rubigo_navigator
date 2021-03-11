import 'dart:async';

import 'package:flutter_riverpod/all.dart';
import 'package:flutter_rubigo_navigator/pages/page_enum.dart';
import 'package:flutter_rubigo_navigator/pages/s020_main_menu/s020_main_menu_page.dart';
import 'package:rubigo_navigator/rubigo.dart';

final s020ControllerProvider = ChangeNotifierProvider<S020Controller>(
  (ref) {
    return S020Controller(
      () => S020MainMenuPage(s020ControllerProvider),
    );
  },
);

class S020Controller extends RubigoController<Pages> {
  S020Controller(RubigoPage<Pages, RubigoController> Function() getRubigoPage)
      : super(getRubigoPage);

  @override
  FutureOr<void> onTop(StackChange stackChange, Pages previousPage) {
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
