import 'package:flutter_rubigo_navigator/navigator/rubigo_navigator.dart';
import 'package:flutter_rubigo_navigator/pages/s030_sub_page/s030_sub_page.dart';

class S020State {
  S020State(this._rubigoNavigator);

  final RubigoNavigator _rubigoNavigator;

  void doContinue() {
    _rubigoNavigator.push(S030SubPage.page);
  }
}
