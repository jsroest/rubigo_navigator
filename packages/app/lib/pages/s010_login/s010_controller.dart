import 'package:flutter_riverpod/all.dart';
import 'package:flutter_rubigo_navigator/pages/page_enum.dart';
import 'package:flutter_rubigo_navigator/pages/s010_login/s010_login.page.dart';
import 'package:rubigo_navigator/rubigo.dart';

final s010ControllerProvider = ChangeNotifierProvider<S010Controller>(
  (ref) {
    return S010Controller(
      S010LoginPage.page,
    );
  },
);

class S010Controller extends RubigoController<Pages> {
  S010Controller(
    RubigoMaterialPage page,
  ) : super(page);

  void doContinue() {
    rubigoNavigator.push(Pages.S020);
  }
}
