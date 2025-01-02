import 'dart:async';

import 'package:example/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';

void main() {
  // Create a RubigoBusyService.
  // This sample demonstrates the usage of the RubigoBusyService.
  // For this to work, a busyWrapper needs to be passed to the RubigoRouter.
  final rubigoBusyService = RubigoBusyService();
  // Create a RubigoRouter for the set of screens defined by the Screens enum.
  final rubigoRouter = RubigoRouter<Screens>(
    availableScreens: availableScreens,
    splashScreenId: Screens.splashScreen,
    busyWrapper: rubigoBusyService.busyWrapper,
  );
  unawaited(
    // Calling init mandatory. While init loads, the splashScreen is shown.
    // Init returns the first screen to show to the user.
    // This callback can be used to initialize the application and only allows
    // user interaction when it's ready.
    rubigoRouter.init(
      getFirstScreenAsync: () async {
        await Future<void>.delayed(const Duration(seconds: 2));
        return Screens.s100;
      },
    ),
  );
  runApp(
    RubigoMaterialApp(
      rubigoRouter: rubigoRouter,
      rubigoBusyService: rubigoBusyService,
    ),
  );
}
