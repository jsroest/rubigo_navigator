import 'package:flutter_riverpod/all.dart';
import 'package:flutter_rubigo_navigator/pages/page_enum.dart';
import 'package:flutter_rubigo_navigator/pages/s030_sub_page/s030_sub_page.dart';
import 'package:rubigo_navigator/rubigo.dart';
import 'package:rubigo_navigator/rubigo_controller.dart';

final s030ControllerProvider = ChangeNotifierProvider<S030Controller>(
  (ref) {
    return S030Controller(
      S030SubPage(s030ControllerProvider),
    );
  },
);

class S030Controller extends RubigoController<Pages> {
  S030Controller(RubigoPage<Pages, RubigoController<Pages>> rubigoPage)
      : super(rubigoPage);

  void doContinue() {
    rubigoNavigator.remove(Pages.S020);
  }
}
