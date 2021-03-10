import 'package:flutter_riverpod/all.dart';
import 'package:flutter_rubigo_navigator/navigator/rubigo_controller.dart';
import 'package:flutter_rubigo_navigator/navigator/rubigo_material_page.dart';
import 'package:flutter_rubigo_navigator/pages/page_enum.dart';
import 'package:flutter_rubigo_navigator/pages/s030_sub_page/s030_sub_page.dart';

final s030ControllerProvider = ChangeNotifierProvider<S030Controller>(
  (ref) {
    return S030Controller(
      S030SubPage.page,
    );
  },
);

class S030Controller extends RubigoController<Pages> {
  S030Controller(
    RubigoMaterialPage page,
  ) : super(page);

  void doContinue() {
    rubigoNavigator.remove(Pages.S020);
  }
}
