import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';

import 'helpers/rubigo_navigator_observer.dart';
import 'helpers/rubigo_navigator_observer.mocks.dart';
import 'helpers/rubigo_screen_creators.dart';
import 'helpers/screens/mocks/mock_controller.dart';
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

  Future<void> _widgetTest(
      WidgetTester tester, BackCallback backCallback) async {
    final holder = RubigoControllerHolder<MockController<Screens>>();
    final availableScreens = [
      getSplashScreen(holder),
      getS100Screen(holder),
      getS200Screen(holder),
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
        routerDelegate: RubigoRouterDelegate(
          observers: [
            mockNavigatorObserver,
            rubigoNavigatorObserver,
          ],
          rubigoRouter: rubigoRouter,
          backCallback: backCallback,
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
    await tester.pumpAndSettle(const Duration(milliseconds: 200));
    verifyInOrder(
      [
        mockNavigatorObserver.didPush(any, any),
        mockNavigatorObserver.didRemove(any, any),
        mockNavigatorObserver.didChangeTop(any, any),
      ],
    );
    expect(rubigoNavigatorObserver.currentScreenId, Screens.s100);
    await tester.runAsync(() => rubigoRouter.push(Screens.s200));
    await tester.pumpAndSettle();
    expect(rubigoNavigatorObserver.currentScreenId, Screens.s200);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(rubigoNavigatorObserver.currentScreenId, Screens.s100);
  }

  testWidgets(
    'test onPopPage SplashWidget S100 S200 pop',
    (tester) async {
      await _widgetTest(tester, BackCallback.onPopPage);
    },
  );

  testWidgets(
    'test onDidRemovePage SplashWidget S100 S200 pop',
    (tester) async {
      await _widgetTest(tester, BackCallback.onDidRemovePage);
    },
  );
}
