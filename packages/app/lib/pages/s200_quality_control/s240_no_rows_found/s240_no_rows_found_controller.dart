import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_rubigo_navigator/pages/page_enum.dart';
import 'package:flutter_rubigo_navigator/pages/s200_quality_control/s240_no_rows_found/s240_no_rows_found_page.dart';
import 'package:rubigo_navigator/rubigo.dart';

final s240NoRowsFoundControllerProvider =
    ChangeNotifierProvider<S240NoRowsFoundController>(
  (ref) {
    return S240NoRowsFoundController(
      () => S240NoRowsFoundPage(s240NoRowsFoundControllerProvider),
    );
  },
);

class S240NoRowsFoundController extends RubigoController<Pages> {
  S240NoRowsFoundController(
      RubigoPage<Pages, RubigoController> Function() getRubigoPage)
      : super(getRubigoPage);

  void onOkPressed() {
    rubigoNavigator.popTo(Pages.s100MainMenu);
  }
}
