import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_rubigo_navigator/pages/pages.dart';
import 'package:flutter_rubigo_navigator/pages/s200_quality_control/s220_all_rows_done/s220_all_rows_done_page.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';

final s220AllRowsDoneControllerProvider =
    ChangeNotifierProvider<S220AllRowsDoneController>(
  (ref) {
    return S220AllRowsDoneController(
      () => S220AllRowsDonePage(s220AllRowsDoneControllerProvider),
    );
  },
);

class S220AllRowsDoneController extends RubigoController<Pages> {
  S220AllRowsDoneController(
      RubigoPage<Pages, RubigoController> Function() createRubigoPage)
      : super(createRubigoPage);

  @override
  FutureOr<void> willShow() {
    Future<void>.delayed(
      Duration(seconds: 2),
      () => rubigoNavigator.popTo(Pages.s100MainMenu),
    );
  }

  @override
  FutureOr<bool> mayPop() => false;
}
