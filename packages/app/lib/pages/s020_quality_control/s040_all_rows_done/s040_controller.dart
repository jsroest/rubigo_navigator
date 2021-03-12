import 'package:flutter_riverpod/all.dart';
import 'package:flutter_rubigo_navigator/pages/page_enum.dart';
import 'package:flutter_rubigo_navigator/pages/s020_quality_control/s040_all_rows_done/s040_all_rows_done_page.dart';
import 'package:rubigo_navigator/rubigo.dart';

final s040ControllerProvider = ChangeNotifierProvider<S040Controller>(
  (ref) {
    return S040Controller(
      () => S040AllRowsDonePage(s040ControllerProvider),
    );
  },
);

class S040Controller extends RubigoController<Pages> {
  S040Controller(RubigoPage<Pages, RubigoController> Function() getRubigoPage)
      : super(getRubigoPage);

  void onOkPressed() {
    rubigoNavigator.popTo(Pages.s010MainMenu);
  }
}
