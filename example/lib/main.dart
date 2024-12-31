import 'dart:async';

import 'package:example/app.dart';
import 'package:example/dependency_injection.dart';
import 'package:example/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';

void main() {
  final rubigoBusyService = RubigoBusyService();
  getIt.registerSingleton(rubigoBusyService);
  final rubigoRouter = RubigoRouter<Screens>(
    availableScreens: availableScreens,
    splashScreenId: Screens.splashScreen,
    protectWrapper: rubigoBusyService.protectWrapper,
  );
  getIt.registerSingleton(rubigoRouter);

  unawaited(setup());
  runApp(const App());
}
