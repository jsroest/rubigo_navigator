import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';

import 'helpers/screens/s100/s100_controller.dart';
import 'helpers/screens/s100/s100_screen.dart';
import 'helpers/screens/s200/s200_controller.dart';
import 'helpers/screens/s200/s200_screen.dart';
import 'helpers/screens/s300/s300_controller.dart';
import 'helpers/screens/s300/s300_screen.dart';
import 'helpers/screens/s500/s500_controller.dart';
import 'helpers/screens/s500/s500_screen.dart';
import 'helpers/screens/s600/s600_controller.dart';
import 'helpers/screens/s600/s600_screen.dart';
import 'helpers/screens/s700/s700_controller.dart';
import 'helpers/screens/s700/s700_screen.dart';
import 'helpers/screens/screens.dart';
import 'helpers/screens/splash_screen/splash_controller.dart';
import 'helpers/screens/splash_screen/splash_screen.dart';
import 'rubigo_navigator_observer.dart';
import 'widget_test.mocks.dart';

@GenerateNiceMocks([MockSpec<NavigatorObserver>()])
void main() {
  late MockNavigatorObserver navigatorObserver;
  late RubigoNavigatorObserver rubigoNavigatorObserver;
  setUp(
    () {
      navigatorObserver = MockNavigatorObserver();
      rubigoNavigatorObserver = RubigoNavigatorObserver<Screens>();
    },
  );
  testWidgets(
    'test splashWidget',
    (tester) async {
      final holder = RubigoControllerHolder<Screens>();
      final availableScreens = [
        RubigoScreen(
          Screens.splashScreen,
          SplashScreen(),
          () => holder.get(SplashController.new),
        ),
        RubigoScreen(
          Screens.s100,
          S100Screen(),
          () => holder.get(S100Controller.new),
        ),
        RubigoScreen(
          Screens.s200,
          S200Screen(),
          () => holder.get(S200Controller.new),
        ),
        RubigoScreen(
          Screens.s300,
          S300Screen(),
          () => holder.get(S300Controller.new),
        ),
        RubigoScreen(
          Screens.s500,
          S500Screen(),
          () => holder.get(S500Controller.new),
        ),
        RubigoScreen(
          Screens.s600,
          S600Screen(),
          () => holder.get(S600Controller.new),
        ),
        RubigoScreen(
          Screens.s700,
          S700Screen(),
          () => holder.get(S700Controller.new),
        ),
      ];
      await tester.pumpWidget(
        RubigoMaterialApp(
          routerDelegate: RubigoRouterDelegate(
            observers: [
              navigatorObserver,
              rubigoNavigatorObserver,
            ],
            rubigoRouter: RubigoRouter(
              availableScreens: availableScreens,
              splashScreenId: Screens.splashScreen,
            ),
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
          navigatorObserver.navigator,
          navigatorObserver.didPush(any, any),
          navigatorObserver.didChangeTop(any, any),
        ],
      );
      expect(rubigoNavigatorObserver.currentScreenId, Screens.splashScreen);
      await tester.pumpAndSettle(const Duration(milliseconds: 200));
      verifyInOrder(
        [
          navigatorObserver.didPush(any, any),
          navigatorObserver.didRemove(any, any),
          navigatorObserver.didChangeTop(any, any),
        ],
      );
      expect(rubigoNavigatorObserver.currentScreenId, Screens.s100);
    },
  );
}
