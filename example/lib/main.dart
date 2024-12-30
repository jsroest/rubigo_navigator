import 'dart:async';

import 'package:example/app.dart';
import 'package:example/dependency_injection.dart';
import 'package:example/screens/screens.dart';
import 'package:example/widgets/splash_widget.dart';
import 'package:flutter/material.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';

void main() {
  final rubigoBusyService = RubigoBusyService();
  getIt.registerSingleton(rubigoBusyService);
  final rubigoRouter = RubigoRouter<Screens>(
    splashWidget: const SplashWidget(),
    protect: rubigoBusyService.protect,
  );
  getIt.registerSingleton(rubigoRouter);

  unawaited(setup());
  runApp(const App());
}
