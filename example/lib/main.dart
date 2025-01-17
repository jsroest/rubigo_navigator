import 'dart:async';

import 'package:example/holder.dart';
import 'package:example/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:rubigo_router/rubigo_router.dart';

void main() {
  // Create a RubigoRouter for the set of screens defined by the Screens enum.
  // Pass it all available screens and the one to use as a splash screen.
  final rubigoRouter = RubigoRouter<Screens>(
    availableScreens: availableScreens,
    splashScreenId: Screens.splashScreen,
  );

  // Add the router to the service locator.
  holder.add(rubigoRouter);

  // Create a RubigoRouterDelegate.
  final routerDelegate = RubigoRouterDelegate(
    rubigoRouter: rubigoRouter,
  );

  // Calling init is mandatory. While init executes, the splashScreen is shown.
  // Init returns the first screen to show to the user.
  // This callback can be used to initialize the application.For this to work,
  // the splashScreen should not accept any user interaction.
  Future<Screens> initAndGetFirstScreen() async {
    await Future<void>.delayed(const Duration(seconds: 2));
    return Screens.s100;
  }

  runApp(
    // Here we use a RubigoMaterialApp to reduce the complexity of this example.
    // You might want to replicate the contents of the RubigoMaterialApp and
    // adjust it to your needs for more complex scenarios.
    RubigoMaterialApp(
      initAndGetFirstScreen: initAndGetFirstScreen,
      routerDelegate: routerDelegate,
    ),
  );
}
