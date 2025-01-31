import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rubigo_router/rubigo_router.dart';

import '../screens/s100/s100_controller.dart';
import '../screens/s100/s100_screen.dart';
import '../screens/s200/s200_controller.dart';
import '../screens/s200/s200_screen.dart';
import '../screens/s300/s300_controller.dart';
import '../screens/s300/s300_screen.dart';
import '../screens/screens.dart';
import '../screens/splash_screen/splash_controller.dart';
import '../screens/splash_screen/splash_screen.dart';
import 'helpers/rubigo_router_observer.dart';
import 'helpers/rubigo_router_observer.mocks.dart';

void main() {
  late MockNavigatorObserver mockNavigatorObserver;
  late RubigoNavigatorObserver rubigoNavigatorObserver;
  late RubigoRouter<Screens> rubigoRouter;

  setUp(
    () {
      mockNavigatorObserver = MockNavigatorObserver();
      rubigoNavigatorObserver = RubigoNavigatorObserver<Screens>();
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
      ];
      rubigoRouter = RubigoRouter(
        availableScreens: availableScreens,
        splashScreenId: Screens.splashScreen,
      );
    },
  );

  testWidgets(
    'SplashScreen to S100, with delay  in init ',
    (tester) async {
      await tester.pumpWidget(
        RubigoMaterialApp(
          backButtonDispatcher: RubigoRootBackButtonDispatcher(rubigoRouter),
          routerDelegate: RubigoRouterDelegate(
            observers: [
              mockNavigatorObserver,
              rubigoNavigatorObserver,
            ],
            rubigoRouter: rubigoRouter,
          ),
          initAndGetFirstScreen: () async {
            await Future<void>.delayed(const Duration(milliseconds: 200));
            return Screens.s100;
          },
        ),
      );
      await tester.pumpAndSettle();
      verifyInOrder(
        [
          mockNavigatorObserver.navigator,
          mockNavigatorObserver.didPush(any, any),
          mockNavigatorObserver.didChangeTop(any, any),
        ],
      );
      expect(rubigoNavigatorObserver.currentScreenId, Screens.splashScreen);
      await tester.pump(const Duration(milliseconds: 300));
      verifyInOrder(
        [
          mockNavigatorObserver.didPush(any, any),
          mockNavigatorObserver.didRemove(any, any),
          mockNavigatorObserver.didChangeTop(any, any),
        ],
      );
      expect(rubigoNavigatorObserver.currentScreenId, Screens.s100);
      expect(rubigoRouter.busyService.enabled, true);
    },
  );

  testWidgets(
    'SplashScreen to S100, no delay  in init ',
    (tester) async {
      await tester.pumpWidget(
        RubigoMaterialApp(
          backButtonDispatcher: RubigoRootBackButtonDispatcher(rubigoRouter),
          routerDelegate: RubigoRouterDelegate(
            observers: [
              mockNavigatorObserver,
              rubigoNavigatorObserver,
            ],
            rubigoRouter: rubigoRouter,
          ),
          initAndGetFirstScreen: () async => Screens.s100,
        ),
      );
      await tester.pumpAndSettle();
      verifyInOrder(
        [
          mockNavigatorObserver.navigator,
          mockNavigatorObserver.didPush(any, any),
          mockNavigatorObserver.didChangeTop(any, any),
          mockNavigatorObserver.didPush(any, any),
          mockNavigatorObserver.didRemove(any, any),
          mockNavigatorObserver.didChangeTop(any, any),
        ],
      );
      expect(rubigoNavigatorObserver.currentScreenId, Screens.s100);
      expect(rubigoRouter.busyService.enabled, true);
    },
  );

  testWidgets(
    'Delayed progress indicator when busy',
    (tester) async {
      await tester.pumpWidget(
        RubigoMaterialApp(
          backButtonDispatcher: RubigoRootBackButtonDispatcher(rubigoRouter),
          routerDelegate: RubigoRouterDelegate(
            observers: [
              mockNavigatorObserver,
              rubigoNavigatorObserver,
            ],
            rubigoRouter: rubigoRouter,
          ),
          initAndGetFirstScreen: () async => Screens.s100,
        ),
      );
      await tester.pumpAndSettle();
      await tester.runAsync(
        () async {
          await rubigoRouter.busyService.busyWrapper(
            () async {
              await Future<void>.delayed(const Duration(milliseconds: 100));
              await tester.pump();
              expect(find.byType(CircularProgressIndicator), findsNothing);
              // The delay before showing a progress indicator is
              // 300 milliseconds. Together with the 100 milliseconds, this
              // should be enough.
              await Future<void>.delayed(const Duration(milliseconds: 300));
              await tester.pump();
              expect(find.byType(CircularProgressIndicator), findsOne);
            },
          );
        },
      );
    },
  );

  testWidgets(
    'S100 ui.push(S200)',
    (tester) async {
      await tester.pumpWidget(
        RubigoMaterialApp(
          backButtonDispatcher: RubigoRootBackButtonDispatcher(rubigoRouter),
          routerDelegate: RubigoRouterDelegate(
            observers: [
              mockNavigatorObserver,
              rubigoNavigatorObserver,
            ],
            rubigoRouter: rubigoRouter,
          ),
          initAndGetFirstScreen: () async => Screens.s100,
        ),
      );
      await tester.pumpAndSettle();
      await tester.runAsync(() async => rubigoRouter.ui.push(Screens.s200));
      await tester.pumpAndSettle();
      expect(find.byType(S200Screen), findsOne);
    },
  );

  testWidgets(
    'S100-S200 UI BackButton',
    (tester) async {
      await tester.pumpWidget(
        RubigoMaterialApp(
          backButtonDispatcher: RubigoRootBackButtonDispatcher(rubigoRouter),
          routerDelegate: RubigoRouterDelegate(
            observers: [
              mockNavigatorObserver,
              rubigoNavigatorObserver,
            ],
            rubigoRouter: rubigoRouter,
          ),
          initAndGetFirstScreen: () async => Screens.s100,
        ),
      );
      await tester.pumpAndSettle();
      await tester.runAsync(() async => rubigoRouter.ui.push(Screens.s200));
      await tester.pumpAndSettle();
      expect(find.byType(S200Screen), findsOne);
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.byType(S100Screen), findsOne);
    },
  );

  testWidgets(
    'S100-S200 UI BackButton, when busy',
    (tester) async {
      await tester.pumpWidget(
        RubigoMaterialApp(
          backButtonDispatcher: RubigoRootBackButtonDispatcher(rubigoRouter),
          routerDelegate: RubigoRouterDelegate(
            observers: [
              mockNavigatorObserver,
              rubigoNavigatorObserver,
            ],
            rubigoRouter: rubigoRouter,
          ),
          initAndGetFirstScreen: () async => Screens.s100,
        ),
      );
      await tester.pumpAndSettle();
      await tester.runAsync(() async => rubigoRouter.ui.push(Screens.s200));
      await tester.pumpAndSettle();
      expect(find.byType(S200Screen), findsOne);
      await tester.runAsync(() async {
        await rubigoRouter.busyService.busyWrapper(() async {
          await tester.pump();
          //This should give a warning in the log that it could not be tapped.
          await tester.pageBack();
        });
      });
      await tester.pumpAndSettle();
      expect(find.byType(S200Screen), findsOne);
    },
  );

  testWidgets(
    'S100-S200 Hardware BackButton',
    (tester) async {
      final backButtonDispatcher = RubigoRootBackButtonDispatcher(rubigoRouter);
      await tester.pumpWidget(
        RubigoMaterialApp(
          backButtonDispatcher: backButtonDispatcher,
          routerDelegate: RubigoRouterDelegate(
            observers: [
              mockNavigatorObserver,
              rubigoNavigatorObserver,
            ],
            rubigoRouter: rubigoRouter,
          ),
          initAndGetFirstScreen: () async => Screens.s100,
        ),
      );
      await tester.pumpAndSettle();
      await tester.runAsync(() async => rubigoRouter.ui.push(Screens.s200));
      await tester.pumpAndSettle();
      expect(find.byType(S200Screen), findsOne);
      await tester.runAsync(() async => backButtonDispatcher.didPopRoute());
      await tester.pumpAndSettle();
      expect(find.byType(S100Screen), findsOne);
    },
  );

  testWidgets(
    'S100-S200 Hardware BackButton, when busy',
    (tester) async {
      final backButtonDispatcher = RubigoRootBackButtonDispatcher(rubigoRouter);
      await tester.pumpWidget(
        RubigoMaterialApp(
          backButtonDispatcher: backButtonDispatcher,
          routerDelegate: RubigoRouterDelegate(
            observers: [
              mockNavigatorObserver,
              rubigoNavigatorObserver,
            ],
            rubigoRouter: rubigoRouter,
          ),
          initAndGetFirstScreen: () async => Screens.s100,
        ),
      );
      await tester.pumpAndSettle();
      await tester.runAsync(() async => rubigoRouter.ui.push(Screens.s200));
      await tester.pumpAndSettle();
      expect(find.byType(S200Screen), findsOne);
      await tester.runAsync(() async {
        await rubigoRouter.busyService.busyWrapper(() async {
          await tester.pump();
          //This should give a warning in the log that it could not be tapped.
          await backButtonDispatcher.didPopRoute();
        });
      });
      await tester.pumpAndSettle();
      expect(find.byType(S200Screen), findsOne);
    },
  );

  testWidgets(
    'S100-S200 Hardware BackButton, when dialog shows',
    (tester) async {
      final backButtonDispatcher = RubigoRootBackButtonDispatcher(rubigoRouter);
      await tester.pumpWidget(
        RubigoMaterialApp(
          backButtonDispatcher: backButtonDispatcher,
          routerDelegate: RubigoRouterDelegate(
            observers: [
              mockNavigatorObserver,
              rubigoNavigatorObserver,
            ],
            rubigoRouter: rubigoRouter,
          ),
          initAndGetFirstScreen: () async => Screens.s100,
        ),
      );
      await tester.pumpAndSettle();
      await tester.runAsync(() async => rubigoRouter.ui.push(Screens.s200));
      await tester.pumpAndSettle();
      expect(find.byType(S200Screen), findsOne);
      await tester.runAsync(() async {
        unawaited(testShowDialog(rubigoRouter));
      });
      await tester.pumpAndSettle();
      expect(currentRouteIsPage(rubigoRouter), false);
      await tester.runAsync(() async => backButtonDispatcher.didPopRoute());
      await tester.pumpAndSettle();
      expect(currentRouteIsPage(rubigoRouter), true);
      await tester.pumpAndSettle();
      expect(find.byType(S200Screen), findsOne);
    },
  );

  testWidgets(
    'S100-S200 Dialog shows, press button',
    (tester) async {
      final backButtonDispatcher = RubigoRootBackButtonDispatcher(rubigoRouter);
      await tester.pumpWidget(
        RubigoMaterialApp(
          backButtonDispatcher: backButtonDispatcher,
          routerDelegate: RubigoRouterDelegate(
            observers: [
              mockNavigatorObserver,
              rubigoNavigatorObserver,
            ],
            rubigoRouter: rubigoRouter,
          ),
          initAndGetFirstScreen: () async => Screens.s100,
        ),
      );
      await tester.pumpAndSettle();
      await tester.runAsync(() async => rubigoRouter.ui.push(Screens.s200));
      await tester.pumpAndSettle();
      expect(find.byType(S200Screen), findsOne);
      await tester.runAsync(() async {
        unawaited(testShowDialog(rubigoRouter));
      });
      expect(currentRouteIsPage(rubigoRouter), false);
      await tester.pumpAndSettle();
      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();
      expect(currentRouteIsPage(rubigoRouter), true);
      await tester.pumpAndSettle();
      expect(find.byType(S200Screen), findsOne);
    },
  );
}

Future<void> testShowDialog(RubigoRouter rubigoRouter) async {
  rubigoRouter.busyService.enabled = false;
  await showDialog<void>(
    context: rubigoRouter.navigatorKey.currentContext!,
    builder: (context) {
      return AlertDialog(
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
  rubigoRouter.busyService.enabled = true;
}
