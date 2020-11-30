import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_rubigo_navigator/app.dart';
import 'package:flutter_rubigo_navigator/navigator/controller.dart';
import 'package:flutter_rubigo_navigator/navigator/rubigo_navigator.dart';
import 'package:flutter_rubigo_navigator/pages/s010_login/s010_login.page.dart';
import 'package:flutter_rubigo_navigator/pages/s020_main_menu/s020_controller.dart';

final s010ControllerProvider = ChangeNotifierProvider<S010Controller>(
  (ref) {
    return S010Controller(
      ref.watch(rubigoNavigatorProvider),
      ref.watch(s020ControllerProvider),
    );
  },
);

class S010Controller extends Controller {
  S010Controller(
    this._rubigoNavigator,
    this._s020controller,
  ) : super(S010LoginPage.page);

  final RubigoNavigator _rubigoNavigator;
  final S020Controller _s020controller;

  void doContinue() {
    _rubigoNavigator.push(_s020controller);
  }
}
