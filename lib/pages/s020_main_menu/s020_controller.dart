import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_rubigo_navigator/navigator/controller.dart';
import 'package:flutter_rubigo_navigator/navigator/rubigo_navigator.dart';
import 'package:flutter_rubigo_navigator/pages/s020_main_menu/s020_main_menu_page.dart';
import 'package:flutter_rubigo_navigator/pages/s030_sub_page/s030_state.dart';

final s020ControllerProvider = ChangeNotifierProvider<S020Controller>(
  (ref) {
    return S020Controller(
      ref.read(rubigoNavigatorProvider),
    );
  },
);

class S020Controller extends Controller {
  S020Controller(
    this._rubigoNavigator,
  ) : super(S020MainMenuPage.page);

  final RubigoNavigator _rubigoNavigator;

  void doContinue() {
    _rubigoNavigator.push(S030Controller);
  }
}
