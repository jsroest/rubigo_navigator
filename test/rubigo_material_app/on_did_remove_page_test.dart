import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rubigo_router/rubigo_router.dart';

import '../screens/s100/s100_controller.dart';
import '../screens/s100/s100_screen.dart';
import '../screens/s200/s200_controller.dart';
import '../screens/s200/s200_screen.dart';
import '../screens/s300/s300_controller.dart';
import '../screens/s300/s300_screen.dart';
import '../screens/s400/s400_controller.dart';
import '../screens/s400/s400_screen.dart';
import '../screens/screens.dart';
import '../screens/splash_screen/splash_controller.dart';
import '../screens/splash_screen/splash_screen.dart';

void main() {
  late RubigoRouter<Screens> rubigoRouter;

  setUp(
    () {
      final holder = RubigoHolder();
      final availableScreens = [
        RubigoScreen(
          Screens.splashScreen,
          SplashScreen(),
          () => holder.getOrCreate(SplashRubigoController.new),
        ),
        RubigoScreen(
          Screens.s100,
          S100Screen(),
          () => holder.getOrCreate(S100RubigoController.new),
        ),
        RubigoScreen(
          Screens.s200,
          S200Screen(),
          () => holder.getOrCreate(S200RubigoController.new),
        ),
        RubigoScreen(
          Screens.s300,
          S300Screen(),
          () => holder.getOrCreate(S300RubigoController.new),
        ),
        RubigoScreen(
          Screens.s400,
          S400Screen(),
          () => holder.getOrCreate(S400RubigoController.new),
        ),
      ];
      rubigoRouter = RubigoRouter(
        availableScreens: availableScreens,
        splashScreenId: Screens.splashScreen,
      );
    },
  );

  testWidgets('test a back gesture S100-S200 to S100', (tester) async {
    await tester.pumpWidget(
      RubigoMaterialApp(
        backButtonDispatcher: RubigoRootBackButtonDispatcher(rubigoRouter),
        routerDelegate: RubigoRouterDelegate(
          rubigoRouter: rubigoRouter,
        ),
        initAndGetFirstScreen: () async => Screens.s100,
      ),
    );
    await tester.pumpAndSettle();
    await tester.runAsync(() async => rubigoRouter.ui.push(Screens.s200));
    await tester.pumpAndSettle();
    // Start perform a back gesture
    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    late final TransitionRoute<void> lastRoute;
    // https://stackoverflow.com/questions/50817086/how-to-check-which-the-current-route-is/50817399#50817399
    navigator.popUntil(
      (route) {
        lastRoute = route as TransitionRoute<void>;
        return true;
      },
    );
    lastRoute.handleStartBackGesture(progress: 75);
    await tester.pumpAndSettle();
    lastRoute.handleCommitBackGesture();
    // End perform a back gesture
    await tester.pumpAndSettle();
    expect(find.byType(S100Screen), findsOne);
  });

  testWidgets('onDidRemovePage - updateScreensIsCalled is false',
      (tester) async {
    await tester.pumpWidget(
      RubigoMaterialApp(
        backButtonDispatcher: RubigoRootBackButtonDispatcher(rubigoRouter),
        routerDelegate: RubigoRouterDelegate(
          rubigoRouter: rubigoRouter,
        ),
        initAndGetFirstScreen: () async => Screens.s100,
      ),
    );
    await tester.pumpAndSettle();
    await tester.runAsync(() async => rubigoRouter.ui.push(Screens.s200));
    await tester.pumpAndSettle();
    await tester.runAsync(() async => rubigoRouter.ui.push(Screens.s300));
    await tester.pumpAndSettle();
    await tester.runAsync(() async => rubigoRouter.ui.push(Screens.s400));
    await tester.pumpAndSettle();
    // Start perform a back gesture
    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    late final TransitionRoute<void> lastRoute;
    // https://stackoverflow.com/questions/50817086/how-to-check-which-the-current-route-is/50817399#50817399
    navigator.popUntil(
      (route) {
        lastRoute = route as TransitionRoute<void>;
        return true;
      },
    );
    lastRoute.handleStartBackGesture(progress: 75);
    await tester.pumpAndSettle();
    lastRoute.handleCommitBackGesture();
    // End perform a back gesture
    await tester.pumpAndSettle();
    expect(find.byType(S400Screen), findsOne);
  });

  testWidgets('onDidRemovePage - execute workaround', (tester) async {
    await tester.pumpWidget(
      RubigoMaterialApp(
        backButtonDispatcher: RubigoRootBackButtonDispatcher(rubigoRouter),
        routerDelegate: RubigoRouterDelegate(
          rubigoRouter: rubigoRouter,
        ),
        initAndGetFirstScreen: () async => Screens.s100,
      ),
    );
    await tester.pumpAndSettle();
    await tester.runAsync(() async => rubigoRouter.ui.push(Screens.s200));
    await tester.pumpAndSettle();
    await tester.runAsync(() async => rubigoRouter.ui.push(Screens.s300));
    await tester.pumpAndSettle();
    await tester.runAsync(() async => rubigoRouter.ui.push(Screens.s400));
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.byType(S400Screen), findsOne);
  });
}
