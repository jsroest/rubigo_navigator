import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_rubigo_navigator/main.dart';
import 'package:flutter_rubigo_navigator/navigator/rubigo.dart';
import 'package:flutter_rubigo_navigator/pages/page_enum.dart';
import 'package:flutter_rubigo_navigator/pages/s010_login/s010_login.page.dart';

final s010ControllerProvider = ChangeNotifierProvider<S010Controller>(
  (ref) {
    return S010Controller(
      S010LoginPage.page,
      ref.read(appNavigatorProvider),
    );
  },
);

class S010Controller extends RubigoController<Pages> {
  S010Controller(
    RubigoMaterialPage page,
    RubigoNavigator<Pages> rubigoNavigator,
  ) : super(page, rubigoNavigator);

  void doContinue() {
    rubigoNavigator.push(Pages.S020);
  }
}
