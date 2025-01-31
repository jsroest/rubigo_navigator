import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rubigo_router/rubigo_router.dart';

import '../mock_controller/mock_controller.dart';
import 'helpers/rubigo_router_observer.dart';
import 'helpers/rubigo_router_observer.mocks.dart';

void main() {
  late MockNavigatorObserver mockNavigatorObserver;
  late RubigoNavigatorObserver rubigoNavigatorObserver;
  late RubigoRouter<_Screens> rubigoRouter;

  setUp(
    () {
      mockNavigatorObserver = MockNavigatorObserver();
      rubigoNavigatorObserver = RubigoNavigatorObserver<_Screens>();
      final holder = RubigoHolder();
      final availableScreens = [
        RubigoScreen(
          _Screens.splashScreen,
          const _SplashScreen(),
          () => holder.getOrCreate(_SplashController.new),
        ),
        RubigoScreen(
          _Screens.s100,
          _S100Screen(),
          () => holder.getOrCreate(_S100Controller.new),
        ),
        RubigoScreen(
          _Screens.s200,
          _S200Screen(),
          () => holder.getOrCreate(_S200Controller.new),
        ),
      ];
      rubigoRouter = RubigoRouter(
        availableScreens: availableScreens,
        splashScreenId: _Screens.splashScreen,
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
            return _Screens.s100;
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
      expect(rubigoNavigatorObserver.currentScreenId, _Screens.splashScreen);
      await tester.pump(const Duration(milliseconds: 300));
      verifyInOrder(
        [
          mockNavigatorObserver.didPush(any, any),
          mockNavigatorObserver.didRemove(any, any),
          mockNavigatorObserver.didChangeTop(any, any),
        ],
      );
      expect(rubigoNavigatorObserver.currentScreenId, _Screens.s100);
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
          initAndGetFirstScreen: () async => _Screens.s100,
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
      expect(rubigoNavigatorObserver.currentScreenId, _Screens.s100);
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
          initAndGetFirstScreen: () async => _Screens.s100,
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
          initAndGetFirstScreen: () async => _Screens.s100,
        ),
      );
      await tester.pumpAndSettle();
      await tester.runAsync(() async => rubigoRouter.ui.push(_Screens.s200));
      await tester.pumpAndSettle();
      expect(find.byType(_S200Screen), findsOne);
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
          initAndGetFirstScreen: () async => _Screens.s100,
        ),
      );
      await tester.pumpAndSettle();
      await tester.runAsync(() async => rubigoRouter.ui.push(_Screens.s200));
      await tester.pumpAndSettle();
      expect(find.byType(_S200Screen), findsOne);
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.byType(_S100Screen), findsOne);
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
          initAndGetFirstScreen: () async => _Screens.s100,
        ),
      );
      await tester.pumpAndSettle();
      await tester.runAsync(() async => rubigoRouter.ui.push(_Screens.s200));
      await tester.pumpAndSettle();
      expect(find.byType(_S200Screen), findsOne);
      await tester.runAsync(() async {
        await rubigoRouter.busyService.busyWrapper(() async {
          await tester.pump();
          //This should give a warning in the log that it could not be tapped.
          await tester.pageBack();
        });
      });
      await tester.pumpAndSettle();
      expect(find.byType(_S200Screen), findsOne);
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
          initAndGetFirstScreen: () async => _Screens.s100,
        ),
      );
      await tester.pumpAndSettle();
      await tester.runAsync(() async => rubigoRouter.ui.push(_Screens.s200));
      await tester.pumpAndSettle();
      expect(find.byType(_S200Screen), findsOne);
      await tester.runAsync(() async => backButtonDispatcher.didPopRoute());
      await tester.pumpAndSettle();
      expect(find.byType(_S100Screen), findsOne);
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
          initAndGetFirstScreen: () async => _Screens.s100,
        ),
      );
      await tester.pumpAndSettle();
      await tester.runAsync(() async => rubigoRouter.ui.push(_Screens.s200));
      await tester.pumpAndSettle();
      expect(find.byType(_S200Screen), findsOne);
      await tester.runAsync(() async {
        await rubigoRouter.busyService.busyWrapper(() async {
          await tester.pump();
          //This should give a warning in the log that it could not be tapped.
          await backButtonDispatcher.didPopRoute();
        });
      });
      await tester.pumpAndSettle();
      expect(find.byType(_S200Screen), findsOne);
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
          initAndGetFirstScreen: () async => _Screens.s100,
        ),
      );
      await tester.pumpAndSettle();
      await tester.runAsync(() async => rubigoRouter.ui.push(_Screens.s200));
      await tester.pumpAndSettle();
      expect(find.byType(_S200Screen), findsOne);
      await tester.runAsync(() async {
        unawaited(_testShowDialog(rubigoRouter));
      });
      await tester.pumpAndSettle();
      expect(currentRouteIsPage(rubigoRouter), false);
      await tester.runAsync(() async => backButtonDispatcher.didPopRoute());
      await tester.pumpAndSettle();
      expect(currentRouteIsPage(rubigoRouter), true);
      await tester.pumpAndSettle();
      expect(find.byType(_S200Screen), findsOne);
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
          initAndGetFirstScreen: () async => _Screens.s100,
        ),
      );
      await tester.pumpAndSettle();
      await tester.runAsync(() async => rubigoRouter.ui.push(_Screens.s200));
      await tester.pumpAndSettle();
      expect(find.byType(_S200Screen), findsOne);
      await tester.runAsync(() async {
        unawaited(_testShowDialog(rubigoRouter));
      });
      expect(currentRouteIsPage(rubigoRouter), false);
      await tester.pumpAndSettle();
      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();
      expect(currentRouteIsPage(rubigoRouter), true);
      await tester.pumpAndSettle();
      expect(find.byType(_S200Screen), findsOne);
    },
  );
}

Future<void> _testShowDialog(RubigoRouter rubigoRouter) async {
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

enum _Screens {
  splashScreen,
  s100,
  s200,
}

//region SplashScreen
class _SplashScreen extends StatelessWidget {
  //ignore: unused_element
  const _SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class _SplashController extends MockController<_Screens> {}
//endregion

//region S100Screen
class _S100Screen extends StatelessWidget
    with RubigoScreenMixin<_S100Controller> {
  //ignore: unused_element
  _S100Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: rubigoBackButton(context, controller.rubigoRouter),
      ),
      body: const Placeholder(),
    );
  }
}

class _S100Controller extends MockController<_Screens> {}
//endregion

//region S200Screen
class _S200Screen extends StatelessWidget
    with RubigoScreenMixin<_S200Controller> {
  //ignore: unused_element
  _S200Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: rubigoBackButton(context, controller.rubigoRouter),
      ),
      body: const Placeholder(),
    );
  }
}

class _S200Controller extends MockController<_Screens> {}
//endregion
