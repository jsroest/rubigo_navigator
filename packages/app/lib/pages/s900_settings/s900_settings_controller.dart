import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_rubigo_navigator/pages/page_enum.dart';
import 'package:flutter_rubigo_navigator/pages/s900_settings/s900_settings_page.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';

final s900SettingsControllerProvider =
    ChangeNotifierProvider<S900SettingsController>(
  (ref) {
    return S900SettingsController(
      () => S900SettingsPage(s900SettingsControllerProvider),
    );
  },
);

class S900SettingsController extends RubigoController<Pages> {
  S900SettingsController(
      RubigoPage<Pages, RubigoController> Function() createRubigoPage)
      : super(createRubigoPage);
}
