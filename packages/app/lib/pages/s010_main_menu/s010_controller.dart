import 'package:flutter_riverpod/all.dart';
import 'package:flutter_rubigo_navigator/pages/page_enum.dart';
import 'package:flutter_rubigo_navigator/pages/s010_main_menu/s010_main_menu_page.dart';
import 'package:rubigo_navigator/rubigo.dart';

final s010ControllerProvider = ChangeNotifierProvider<S010Controller>(
  (ref) {
    return S010Controller(
      () => S010MainMenuPage(s010ControllerProvider),
    );
  },
);

class S010Controller extends RubigoController<Pages> {
  S010Controller(RubigoPage<Pages, RubigoController> Function() getRubigoPage)
      : super(getRubigoPage);

  void onQualityControlTap() {
    rubigoNavigator.push(Pages.s020SelectItem);
  }

  void onSettingsTap() {
    rubigoNavigator.push(Pages.s999Settings);
  }
}
