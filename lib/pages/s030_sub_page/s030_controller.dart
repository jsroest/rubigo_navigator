import 'package:flutter_riverpod/all.dart';
import 'package:flutter_rubigo_navigator/classes/material_page_ex.dart';
import 'package:flutter_rubigo_navigator/navigator/controller.dart';
import 'package:flutter_rubigo_navigator/navigator/rubigo_navigator.dart';
import 'package:flutter_rubigo_navigator/pages/s020_main_menu/s020_controller.dart';
import 'package:flutter_rubigo_navigator/pages/s030_sub_page/s030_sub_page.dart';

enum S030 {
  V01,
  V02,
  V03,
  V04,
  V05,
  V06,
  V07,
  V08,
  V09,
  V10,
}

final s030ControllerProvider =
    ChangeNotifierProvider.family<S030Controller, S030>(
  (ref, id) {
    return S030Controller(
      S030SubPage.page(id),
      ref.read(rubigoNavigatorProvider),
      id.toString(),
    );
  },
);

class S030Controller extends Controller {
  S030Controller(
      MaterialPageEx page, RubigoNavigator rubigoNavigator, String id)
      : super(page, rubigoNavigator, id);

  void doContinue() {
    rubigoNavigator.remove(S020Controller);
  }
}
