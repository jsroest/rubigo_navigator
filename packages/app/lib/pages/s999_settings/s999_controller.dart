import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_rubigo_navigator/pages/page_enum.dart';
import 'package:flutter_rubigo_navigator/pages/s999_settings/s999_settings_page.dart';
import 'package:rubigo_navigator/rubigo.dart';

final s999ControllerProvider = ChangeNotifierProvider<S999Controller>(
  (ref) {
    return S999Controller(
      () => S999SettingsPage(s999ControllerProvider),
    );
  },
);

class S999Controller extends RubigoController<Pages> {
  S999Controller(RubigoPage<Pages, RubigoController> Function() getRubigoPage)
      : super(getRubigoPage);
}
