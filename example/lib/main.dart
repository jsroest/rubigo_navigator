import 'dart:async';

import 'package:example/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';

void main() {
  // Create a RubigoRouter for the set of screens defined by the Screens enum.
  final rubigoRouter = RubigoRouter<Screens>(
    availableScreens: availableScreens,
    splashScreenId: Screens.splashScreen,
  );
  unawaited(
    // Calling init is mandatory. While init loads, the splashScreen is shown.
    // Init returns the first screen to show to the user.
    // This callback can be used to initialize the application and only allows
    // user interaction when it's ready. For this to work, the splashScreen
    // should not accept any user interaction.
    rubigoRouter.init(
      getFirstScreenAsync: () async {
        await Future<void>.delayed(const Duration(seconds: 2));
        return Screens.s100;
      },
    ),
  );
  runApp(
    RubigoMaterialApp(
      routerDelegate: RubigoRouterDelegate(
        rubigoRouter: rubigoRouter,
        widgetToPage: (screen) => MaterialPage(
          child: screen.screenWidget,
          //key: screen.pageKey,
        ),
        backCallback: BackCallback.onPopPage,
      ),
    ),
  );
}
