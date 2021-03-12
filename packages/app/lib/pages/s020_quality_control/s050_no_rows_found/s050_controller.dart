import 'package:flutter_riverpod/all.dart';
import 'package:flutter_rubigo_navigator/pages/page_enum.dart';
import 'package:flutter_rubigo_navigator/pages/s020_quality_control/s050_no_rows_found/s050_no_rows_found_page.dart';
import 'package:rubigo_navigator/rubigo.dart';

final s050ControllerProvider = ChangeNotifierProvider<S050Controller>(
  (ref) {
    return S050Controller(
      () => S050NoRowsFoundPage(s050ControllerProvider),
    );
  },
);

class S050Controller extends RubigoController<Pages> {
  S050Controller(RubigoPage<Pages, RubigoController> Function() getRubigoPage)
      : super(getRubigoPage);

  void onOkPressed() {
    rubigoNavigator.popTo(Pages.s010MainMenu);
  }
}
