import 'package:flutter_riverpod/all.dart';
import 'package:flutter_rubigo_navigator/app.dart';
import 'package:flutter_rubigo_navigator/navigator/controller.dart';
import 'package:flutter_rubigo_navigator/navigator/rubigo_navigator.dart';
import 'package:flutter_rubigo_navigator/pages/s020_main_menu/s020_controller.dart';
import 'package:flutter_rubigo_navigator/pages/s030_sub_page/s030_sub_page.dart';

final s030ControllerProvider = ChangeNotifierProvider<S030Controller>(
  (ref) {
    return S030Controller(
      ref.watch(rubigoNavigatorProvider),
      ref.watch(s020ControllerProvider),
    );
  },
);

class S030Controller extends Controller {
  S030Controller(
    this._rubigoNavigator,
    this._s020controller,
  ) : super(S030SubPage.page);

  final RubigoNavigator _rubigoNavigator;
  final S020Controller _s020controller;

  void doContinue() {
    _rubigoNavigator.remove(_s020controller);
  }
}
