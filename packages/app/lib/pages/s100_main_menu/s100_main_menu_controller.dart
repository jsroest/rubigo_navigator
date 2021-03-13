import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_rubigo_navigator/pages/page_enum.dart';
import 'package:flutter_rubigo_navigator/pages/s100_main_menu/s100_main_menu_page.dart';
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

  void onQualityControlTap() {
    rubigoNavigator.push(Pages.s210SelectItem);
  }

  void onSettingsTap() {
    rubigoNavigator.push(Pages.s900Settings);
  }
}
