import 'package:flutter/widgets.dart';
import 'package:flutter_rubigo_navigator/navigator/rubigo_navigator.dart';
import 'package:flutter_rubigo_navigator/pages/s020_main_menu/s020_main_menu_page.dart';

class S010State extends ChangeNotifier {
  S010State(this._rubigoNavigator);

  final RubigoNavigator _rubigoNavigator;
  void doContinue() {
    _rubigoNavigator.push(S020MainMenuPage.page);
  }
}
