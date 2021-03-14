import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_rubigo_navigator/pages/page_enum.dart';
import 'package:flutter_rubigo_navigator/pages/s200_quality_control/s230_all_rows_done/s230_all_rows_done_page.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';

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
      RubigoPage<Pages, RubigoController> Function() createRubigoPage)
      : super(createRubigoPage);

  @override
  FutureOr<void> isShown() {
    Future<void>.delayed(
      Duration(seconds: 2),
      () => rubigoNavigator.popTo(Pages.s100MainMenu),
    );
  }

  @override
  FutureOr<bool> isPopping() => false;
}
