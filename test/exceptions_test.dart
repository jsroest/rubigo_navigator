import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rubigo_router/rubigo_router.dart';

import 'screens/s100/s100_controller.dart';
import 'screens/s100/s100_screen.dart';
import 'screens/s200/s200_controller.dart';
import 'screens/s200/s200_screen.dart';
import 'screens/s300/s300_controller.dart';
import 'screens/s300/s300_screen.dart';
import 'screens/screens.dart';
import 'screens/splash_screen/splash_controller.dart';
import 'screens/splash_screen/splash_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late RubigoHolder holder;
  late List<RubigoScreen<Screens>> availableScreens;
  late RubigoRouter<Screens> rubigoRouter;

  setUp(
    () async {
      holder = RubigoHolder();
      availableScreens = [
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
      await rubigoRouter.init(
        initAndGetFirstScreen: () async => Screens.s100,
      );
    },
  );

  test(
    'Navigate in willShow',
    () async {
      final s200Controller = holder.get<S200RubigoController>();
      s200Controller.willShowPush = Screens.s300;
      await expectLater(
        () async => rubigoRouter.prog.push(Screens.s200),
        throwsA(
          predicate(
            (e) =>
                e is UnsupportedError &&
                e.message ==
                    'Developer: you may not call push, pop, popTo, '
                        'replaceStack or remove in the willShow method.',
          ),
        ),
      );
    },
  );

  test(
    'Navigate in removedFromStack',
    () async {
      final s200Controller = holder.get<S200RubigoController>();
      s200Controller.removedFromStackPush = Screens.s300;
      await rubigoRouter.prog.push(Screens.s200);
      await expectLater(
        () async => rubigoRouter.prog.pop(),
        throwsA(
          predicate(
            (e) =>
                e is UnsupportedError &&
                e.message ==
                    'Developer: you may not call push, pop, popTo, '
                        'replaceStack or remove in the removedFromStack '
                        'method.',
          ),
        ),
      );
    },
  );

  test(
    'PopTo a screen that is not on the stack',
    () async {
      await expectLater(
        () async => rubigoRouter.prog.popTo(Screens.s200),
        throwsA(
          predicate(
            (e) =>
                e is UnsupportedError &&
                e.message ==
                    'Developer: With popTo, you tried to navigate to s200, '
                        'which was not below this screen on the stack.',
          ),
        ),
      );
    },
  );

  test(
    'PopTo the current screen',
    () async {
      await expectLater(
        () async => rubigoRouter.prog.popTo(Screens.s100),
        throwsA(
          predicate(
            (e) =>
                e is UnsupportedError &&
                e.message ==
                    'Developer: With popTo, you tried to navigate to s100, '
                        'which was not below this screen on the stack.',
          ),
        ),
      );
    },
  );

  test(
    'Remove a screen that is not on the stack',
    () async {
      await expectLater(
        () async => rubigoRouter.prog.remove(Screens.s200),
        throwsA(
          predicate(
            (e) =>
                e is UnsupportedError &&
                e.message ==
                    'Developer: You can only remove screens that exist on the '
                        'stack (s200 not found).',
          ),
        ),
      );
    },
  );

  test(
    'Remove a Page object with key is null',
    () async {
      const page = MaterialPage<void>(child: Placeholder());
      await expectLater(
        () async => rubigoRouter.onDidRemovePage(page),
        throwsA(
          predicate(
            (e) =>
                e is UnsupportedError &&
                e.message ==
                    'PANIC: page.key must be of type ValueKey<Screens>.',
          ),
        ),
      );
    },
  );

  test(
    'Remove a Page object with an invalid ValueKey',
    () async {
      const page = MaterialPage<void>(key: ValueKey(1), child: Placeholder());
      await expectLater(
        () async => rubigoRouter.onDidRemovePage(page),
        throwsA(
          predicate(
            (e) =>
                e is UnsupportedError &&
                e.message ==
                    'PANIC: page.key must be of type ValueKey<Screens>.',
          ),
        ),
      );
    },
  );

  testWidgets(
    'Remove last screen on the stack',
    (tester) async {
      var message = '';
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (value) async {
          message = value.method;
          return null;
        },
      );
      await rubigoRouter.prog.pop();
      expect(message, 'SystemNavigator.pop');
    },
  );
}
