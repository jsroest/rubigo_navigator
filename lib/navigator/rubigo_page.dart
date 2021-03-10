import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:flutter_rubigo_navigator/navigator/rubigo_controller.dart';

abstract class RubigoPage<PAGE_ENUM,
        RUBIGO_CONTROLLER extends RubigoController<PAGE_ENUM>>
    extends StatelessWidget {
  const RubigoPage(this.controllerProvider, {Key key}) : super(key: key);

  final ChangeNotifierProvider<RUBIGO_CONTROLLER> controllerProvider;
}
