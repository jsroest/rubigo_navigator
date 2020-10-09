import 'package:flutter_rubigo_navigator/navigator/rubigo_navigator.dart';
import 'package:flutter_rubigo_navigator/pages/s020_main_menu/s020_main_menu_page.dart';

class S030State {
  S030State(this._rubigoNavigator);

  final RubigoNavigator _rubigoNavigator;

  void doContinue() {
    _rubigoNavigator.remove(S020MainMenuPage.page);
  }
}
