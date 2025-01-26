import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rubigo_router/rubigo_router.dart';

import 'helpers/rubigo_router_observer.dart';
import 'helpers/rubigo_router_observer.mocks.dart';
import 'helpers/rubigo_screen_creators.dart';
import 'helpers/screens/screens.dart';

void main() {
  late MockNavigatorObserver mockNavigatorObserver;
  late RubigoNavigatorObserver rubigoNavigatorObserver;
  setUp(
    () {
      mockNavigatorObserver = MockNavigatorObserver();
      rubigoNavigatorObserver = RubigoNavigatorObserver<Screens>();
    },
  );

  Future<void> rubigoMaterialApp({
    required WidgetTester tester,
    required Widget? progressIndicator,
  }) async {
    final holder = RubigoHolder();
    final availableScreens = [
      getSplashScreen(holder),
      getS100Screen(holder),
      getS200ScreenDelayInOnTop(holder),
      getS300Screen(holder),
      getS500Screen(holder),
      getS600Screen(holder),
      getS700Screen(holder),
    ];
    final rubigoRouter = RubigoRouter(
      availableScreens: availableScreens,
      splashScreenId: Screens.splashScreen,
    );
    await tester.pumpWidget(
      RubigoMaterialApp(
        backButtonDispatcher: RubigoRootBackButtonDispatcher(rubigoRouter),
        progressIndicator: progressIndicator,
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
    await tester.pump(const Duration(seconds: 1));
    verifyInOrder(
      [
        mockNavigatorObserver.didPush(any, any),
        mockNavigatorObserver.didRemove(any, any),
        mockNavigatorObserver.didChangeTop(any, any),
      ],
    );
    expect(rubigoNavigatorObserver.currentScreenId, Screens.s100);
    expect(rubigoRouter.busyService.enabled, true);
    await tester.runAsync(() => rubigoRouter.ui.push(Screens.s200));
    await tester.pump(const Duration(seconds: 2));
    expect(rubigoRouter.busyService.enabled, true);
    await tester.runAsync(
      () async {
        await rubigoRouter.busyService.busyWrapper(
          () async {
            expect(rubigoRouter.busyService.isBusy, true);
            await Future<void>.delayed(const Duration(milliseconds: 500));
            rubigoRouter.busyService.enabled = false;
            await tester.pump(const Duration(milliseconds: 10));
            await Future<void>.delayed(const Duration(milliseconds: 10));
            await tester.pump(const Duration(milliseconds: 10));
            rubigoRouter.busyService.enabled = true;
            await Future<void>.delayed(const Duration(milliseconds: 10));
            await tester.pump(const Duration(milliseconds: 10));
          },
        );
      },
    );
    await tester.pumpAndSettle();
    expect(rubigoNavigatorObserver.currentScreenId, Screens.s200);
    await tester.runAsync(
      () async {
        await rubigoRouter.busyService.busyWrapper(
          () async {
            await rubigoRouter.ui.pop();
            await tester.pumpAndSettle();
          },
        );
      },
    );
    expect(rubigoNavigatorObserver.currentScreenId, Screens.s200);
    await tester.runAsync(() => rubigoRouter.ui.push(Screens.s300));
    await tester.pumpAndSettle();
    expect(rubigoNavigatorObserver.currentScreenId, Screens.s300);
    await tester.pageBack();
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pumpAndSettle();
    expect(rubigoNavigatorObserver.currentScreenId, Screens.s200);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(rubigoNavigatorObserver.currentScreenId, Screens.s100);
    await tester.runAsync(
      () async {
        await rubigoRouter.busyService.busyWrapper(
          () async {
            await rubigoRouter.ui.replaceStack(
              [
                Screens.s100,
                Screens.s200,
                Screens.s300,
              ],
            );
            await tester.pumpAndSettle();
          },
        );
      },
    );
    expect(rubigoNavigatorObserver.currentScreenId, Screens.s100);
    await rubigoRouter.ui.replaceStack(
      [
        Screens.s100,
        Screens.s200,
        Screens.s300,
      ],
    );
    await tester.pumpAndSettle();
    expect(rubigoNavigatorObserver.currentScreenId, Screens.s300);
    await tester.runAsync(
      () async {
        await rubigoRouter.busyService.busyWrapper(
          () async {
            await rubigoRouter.ui.remove(Screens.s200);
            await tester.pumpAndSettle();
          },
        );
      },
    );
    await tester.pumpAndSettle();
    expect(rubigoRouter.screens.value.toListOfScreenId(), [
      Screens.s100,
      Screens.s200,
      Screens.s300,
    ]);
    await rubigoRouter.ui.remove(Screens.s200);
    await tester.pumpAndSettle();
    expect(rubigoRouter.screens.value.toListOfScreenId(), [
      Screens.s100,
      Screens.s300,
    ]);
    await rubigoRouter.ui.replaceStack(
      [
        Screens.s100,
        Screens.s200,
        Screens.s300,
      ],
    );
    await tester.pumpAndSettle();
    await tester.runAsync(
      () async {
        await rubigoRouter.busyService.busyWrapper(
          () async {
            await rubigoRouter.ui.popTo(Screens.s100);
            await tester.pumpAndSettle();
          },
        );
      },
    );
    await tester.pumpAndSettle();
    expect(rubigoRouter.screens.value.toListOfScreenId(), [
      Screens.s100,
      Screens.s200,
      Screens.s300,
    ]);
    await rubigoRouter.ui.popTo(Screens.s100);
    await tester.pumpAndSettle();
    expect(rubigoRouter.screens.value.toListOfScreenId(), [
      Screens.s100,
    ]);
    await tester.runAsync(
      () async {
        await rubigoRouter.busyService.busyWrapper(
          () async {
            await rubigoRouter.ui.push(Screens.s200);
            await tester.pumpAndSettle();
          },
        );
      },
    );
    await tester.pumpAndSettle();
    expect(rubigoRouter.screens.value.toListOfScreenId(), [
      Screens.s100,
    ]);
    await rubigoRouter.ui.replaceStack(
      [
        Screens.s100,
        Screens.s200,
        Screens.s300,
      ],
    );
    await tester.pumpAndSettle();
    await rubigoRouter.ui.pop();
    await tester.pumpAndSettle();
    expect(rubigoRouter.screens.value.toListOfScreenId(), [
      Screens.s100,
      Screens.s200,
    ]);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(rubigoRouter.screens.value.toListOfScreenId(), [
      Screens.s100,
    ]);
  }

  testWidgets(
    'test onPopPage SplashWidget S100 S200 pop',
    (tester) async {
      await rubigoMaterialApp(
        tester: tester,
        progressIndicator: null,
      );
    },
  );

  testWidgets(
    'test onDidRemovePage SplashWidget S100 S200 pop',
    (tester) async {
      await rubigoMaterialApp(
        tester: tester,
        progressIndicator: const CircularProgressIndicator(),
      );
    },
  );
}
