import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rubigo_navigator/rubigo.dart';

abstract class RubigoPage<PAGE_ENUM,
        RUBIGO_CONTROLLER extends RubigoController<PAGE_ENUM>>
    extends StatelessWidget {
  const RubigoPage(this.controllerProvider, {Key key}) : super(key: key);

  final ChangeNotifierProvider<RUBIGO_CONTROLLER> controllerProvider;
}
