import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:flutter_rubigo_navigator/navigator/controller.dart';
import 'package:flutter_rubigo_navigator/pages/s010_login/s010_controller.dart';
import 'package:flutter_rubigo_navigator/pages/s020_main_menu/s020_controller.dart';
import 'package:flutter_rubigo_navigator/pages/s030_sub_page/s030_controller.dart';

final rubigoControllerProvider = Provider<RubigoController>(
  (ref) {
    return RubigoController(
      controllers: [
        ref.read(s010ControllerProvider),
        ref.read(s020ControllerProvider),
        ref.read(s030ControllerProvider),
      ],
      initialScreenController: S010Controller,
    );
  },
);

class RubigoController {
  RubigoController({
    @required this.controllers,
    @required this.initialScreenController,
  });

  final Type initialScreenController;

  final List<Controller> controllers;
}
