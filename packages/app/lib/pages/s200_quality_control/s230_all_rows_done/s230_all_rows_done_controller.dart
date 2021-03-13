import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_rubigo_navigator/pages/page_enum.dart';
import 'package:flutter_rubigo_navigator/pages/s200_quality_control/s230_all_rows_done/s230_all_rows_done_page.dart';
import 'package:rubigo_navigator/rubigo.dart';

final s230AllRowsDoneControllerProvider =
    ChangeNotifierProvider<S230AllRowsDoneController>(
  (ref) {
    return S230AllRowsDoneController(
      () => S230AllRowsDonePage(s230AllRowsDoneControllerProvider),
    );
  },
);

class S230AllRowsDoneController extends RubigoController<Pages> {
  S230AllRowsDoneController(
      RubigoPage<Pages, RubigoController> Function() getRubigoPage)
      : super(getRubigoPage);

  void onOkPressed() {
    rubigoNavigator.popTo(Pages.s100MainMenu);
  }
}
