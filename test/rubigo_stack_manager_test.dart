import 'package:flutter_test/flutter_test.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';
import 'package:rubigo_navigator/src/flutter/screen_to_page_converters.dart';

import 'helpers/helpers.dart';
import 'helpers/screens/s100/s100_controller.dart';
import 'helpers/screens/s100/s100_screen.dart';
import 'helpers/screens/s200/s200_controller.dart';
import 'helpers/screens/s200/s200_controller_may_pop_pop.dart';
import 'helpers/screens/s200/s200_controller_may_pop_push.dart';
import 'helpers/screens/s200/s200_controller_may_pop_returns_false.dart';
import 'helpers/screens/s200/s200_controller_on_top_push_and_pop.dart';
import 'helpers/screens/s200/s200_controller_will_show_pop.dart';
import 'helpers/screens/s200/s200_controller_will_show_push.dart';
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

void main() {
  test('Test s100-s200-s300 pop', () async {
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
        () => holder.get(
          S100Controller.new,
        ),
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
    ];
    final rubigoRouter = RubigoRouter<Screens>(
      splashScreenId: Screens.splashScreen,
      availableScreens: availableScreens,
    );
    await rubigoRouter.init(
      getFirstScreenAsync: () async => Screens.s100,
    );
    await rubigoRouter.push(Screens.s200);
    await rubigoRouter.push(Screens.s300);
    final actualPages = rubigoRouter.screens.toListOfMaterialPage();
    final expectedScreenWidgets1 = [
      Screens.s100,
      Screens.s200,
      Screens.s300,
    ].toListOfWidget(availableScreens);
    checkPages(
      actualPages: actualPages,
      expectedScreenWidgets: expectedScreenWidgets1,
    );
    await rubigoRouter.pop();
    final actualPages2 = rubigoRouter.screens.toListOfMaterialPage();
    final expectedScreenWidgets2 = [
      Screens.s100,
      Screens.s200,
    ].toListOfWidget(availableScreens);
    checkPages(
      actualPages: actualPages2,
      expectedScreenWidgets: expectedScreenWidgets2,
    );
  });

  test(
    'Test s100 pop',
    () async {
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
          () => holder.get(
            S100Controller.new,
          ),
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
      ];
      final rubigoRouter = RubigoRouter<Screens>(
        splashScreenId: Screens.splashScreen,
        availableScreens: availableScreens,
      );
      await rubigoRouter.init(
        getFirstScreenAsync: () async => Screens.s100,
      );
      final actualPages = rubigoRouter.screens.toListOfMaterialPage();
      final expectedScreenWidgets =
          [Screens.s100].toListOfWidget(availableScreens);
      checkPages(
        actualPages: actualPages,
        expectedScreenWidgets: expectedScreenWidgets,
      );
      expect(
        () async => rubigoRouter.pop(),
        throwsA(
          predicate(
            (e) =>
                e is UnsupportedError &&
                e.message ==
                    'Developer: Pop was called on the last screen. The screen stack may not be empty.',
          ),
        ),
      );
    },
  );

  test('Test s100-s200-s300 popTo s100', () async {
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
        () => holder.get(
          S100Controller.new,
        ),
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
    ];
    final rubigoRouter = RubigoRouter<Screens>(
      splashScreenId: Screens.splashScreen,
      availableScreens: availableScreens,
    );
    await rubigoRouter.init(
      getFirstScreenAsync: () async => Screens.s100,
    );
    await rubigoRouter.push(Screens.s200);
    await rubigoRouter.push(Screens.s300);
    final actualPages = rubigoRouter.screens.toListOfMaterialPage();
    final expectedScreenWidgets1 = [
      Screens.s100,
      Screens.s200,
      Screens.s300,
    ].toListOfWidget(availableScreens);
    checkPages(
      actualPages: actualPages,
      expectedScreenWidgets: expectedScreenWidgets1,
    );
    await rubigoRouter.popTo(Screens.s100);
    final actualPages2 = rubigoRouter.screens.toListOfMaterialPage();
    final expectedScreenWidgets2 =
        [Screens.s100].toListOfWidget(availableScreens);
    checkPages(
      actualPages: actualPages2,
      expectedScreenWidgets: expectedScreenWidgets2,
    );
  });

  test(
    'Test s100-s200 popTo s300',
    () async {
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
          () => holder.get(
            S100Controller.new,
          ),
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
      ];
      final rubigoRouter = RubigoRouter<Screens>(
        splashScreenId: Screens.splashScreen,
        availableScreens: availableScreens,
      );
      await rubigoRouter.init(
        getFirstScreenAsync: () async => Screens.s100,
      );
      await rubigoRouter.push(Screens.s200);
      final actualPages = rubigoRouter.screens.toListOfMaterialPage();
      final expectedScreenWidgets1 = [
        Screens.s100,
        Screens.s200,
      ].toListOfWidget(availableScreens);
      checkPages(
        actualPages: actualPages,
        expectedScreenWidgets: expectedScreenWidgets1,
      );
      expect(
        () async => rubigoRouter.popTo(Screens.s300),
        throwsA(
          predicate(
            (e) =>
                e is UnsupportedError &&
                e.message ==
                    'Developer: With popTo, you tried to navigate to s300, which was not on the stack.',
          ),
        ),
      );
    },
  );

  test('Test s100 push s200', () async {
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
        () => holder.get(
          S100Controller.new,
        ),
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
    ];
    final rubigoRouter = RubigoRouter<Screens>(
      splashScreenId: Screens.splashScreen,
      availableScreens: availableScreens,
    );
    await rubigoRouter.init(
      getFirstScreenAsync: () async => Screens.s100,
    );
    final actualPages = rubigoRouter.screens.toListOfMaterialPage();
    final expectedScreenWidgets1 = [
      Screens.s100,
    ].toListOfWidget(availableScreens);
    checkPages(
      actualPages: actualPages,
      expectedScreenWidgets: expectedScreenWidgets1,
    );
    await rubigoRouter.push(Screens.s200);
    final actualPages2 = rubigoRouter.screens.toListOfMaterialPage();
    final expectedScreenWidgets2 = [
      Screens.s100,
      Screens.s200,
    ].toListOfWidget(availableScreens);
    checkPages(
      actualPages: actualPages2,
      expectedScreenWidgets: expectedScreenWidgets2,
    );
  });

  test('Test s100-s200-s300 remove s200', () async {
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
        () => holder.get(
          S100Controller.new,
        ),
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
    ];
    final rubigoRouter = RubigoRouter<Screens>(
      splashScreenId: Screens.splashScreen,
      availableScreens: availableScreens,
    );
    await rubigoRouter.init(
      getFirstScreenAsync: () async => Screens.s100,
    );
    await rubigoRouter.push(Screens.s200);
    await rubigoRouter.push(Screens.s300);
    final actualPages = rubigoRouter.screens.toListOfMaterialPage();
    final expectedScreenWidgets1 = [
      Screens.s100,
      Screens.s200,
      Screens.s300,
    ].toListOfWidget(availableScreens);
    checkPages(
      actualPages: actualPages,
      expectedScreenWidgets: expectedScreenWidgets1,
    );
    rubigoRouter.remove(Screens.s200);
    final actualPages2 = rubigoRouter.screens.toListOfMaterialPage();
    final expectedScreenWidgets2 =
        [Screens.s100, Screens.s300].toListOfWidget(availableScreens);
    checkPages(
      actualPages: actualPages2,
      expectedScreenWidgets: expectedScreenWidgets2,
    );
  });

  test('Test s100-s200 remove s300', () async {
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
        () => holder.get(
          S100Controller.new,
        ),
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
    ];
    final rubigoRouter = RubigoRouter<Screens>(
      splashScreenId: Screens.splashScreen,
      availableScreens: availableScreens,
    );
    await rubigoRouter.init(
      getFirstScreenAsync: () async => Screens.s100,
    );
    await rubigoRouter.push(Screens.s200);
    final actualPages = rubigoRouter.screens.toListOfMaterialPage();
    final expectedScreenWidgets = [
      Screens.s100,
      Screens.s200,
    ].toListOfWidget(availableScreens);
    checkPages(
      actualPages: actualPages,
      expectedScreenWidgets: expectedScreenWidgets,
    );

    expect(
      () => rubigoRouter.remove(Screens.s300),
      throwsA(
        predicate(
          (e) =>
              e is UnsupportedError &&
              e.message ==
                  'Developer: You can only remove screens that exist on the stack (s300 not found).',
        ),
      ),
    );
  });

  test('Test s100 push s100-s200-s300', () async {
    final holder = RubigoControllerHolder<Screens>();
    final availableScreens = [
      RubigoScreen<Screens>(
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
        () => holder.get(S200ControllerOnTopPushAndPop.new),
      ),
      RubigoScreen(Screens.s300, S300Screen(), S300Controller.new),
    ];
    final rubigoRouter = RubigoRouter<Screens>(
      splashScreenId: Screens.splashScreen,
      availableScreens: availableScreens,
    );
    await rubigoRouter.init(
      getFirstScreenAsync: () async => Screens.s100,
    );
    final expectedScreenWidgets1 = [
      Screens.s100,
    ].toListOfWidget(availableScreens);
    final actualPages = rubigoRouter.screens.toListOfMaterialPage();
    checkPages(
      actualPages: actualPages,
      expectedScreenWidgets: expectedScreenWidgets1,
    );
    await rubigoRouter.push(Screens.s200);
    final actualPages2 = rubigoRouter.screens.toListOfMaterialPage();
    final expectedScreenWidgets2 = [
      Screens.s100,
      Screens.s200,
      Screens.s300,
    ].toListOfWidget(availableScreens);
    checkPages(
      actualPages: actualPages2,
      expectedScreenWidgets: expectedScreenWidgets2,
    );
  });

  test('Test s100-s200-s300 pop s100', () async {
    final holder = RubigoControllerHolder<Screens>();
    final availableScreens = [
      RubigoScreen(
        Screens.splashScreen,
        SplashScreen(),
        () => holder.get(SplashController.new),
      ),
      RubigoScreen(Screens.s100, S100Screen(), S100Controller.new),
      RubigoScreen(
        Screens.s200,
        S200Screen(),
        () => holder.get(
          S200ControllerOnTopPushAndPop.new,
        ),
      ),
      RubigoScreen(
        Screens.s300,
        S300Screen(),
        () => holder.get(S300Controller.new),
      ),
    ];
    final rubigoRouter = RubigoRouter<Screens>(
      splashScreenId: Screens.splashScreen,
      availableScreens: availableScreens,
    );
    await rubigoRouter.init(
      getFirstScreenAsync: () async => Screens.s100,
    );
    await rubigoRouter.push(Screens.s200);
    final expectedScreenWidgets1 = [
      Screens.s100,
      Screens.s200,
      Screens.s300,
    ].toListOfWidget(availableScreens);
    final actualPages1 = rubigoRouter.screens.toListOfMaterialPage();
    checkPages(
      actualPages: actualPages1,
      expectedScreenWidgets: expectedScreenWidgets1,
    );
    await rubigoRouter.pop();
    final actualPages2 = rubigoRouter.screens.toListOfMaterialPage();
    final expectedScreenWidgets2 = [
      Screens.s100,
    ].toListOfWidget(availableScreens);
    checkPages(
      actualPages: actualPages2,
      expectedScreenWidgets: expectedScreenWidgets2,
    );
  });

  test('Push in willShow', () async {
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
        () => holder.get(S200ControllerWillShowPush.new),
      ),
      RubigoScreen(
        Screens.s300,
        S300Screen(),
        () => holder.get(S300Controller.new),
      ),
    ];
    final rubigoRouter = RubigoRouter<Screens>(
      splashScreenId: Screens.splashScreen,
      availableScreens: availableScreens,
    );
    await rubigoRouter.init(
      getFirstScreenAsync: () async => Screens.s100,
    );
    expect(
      () async => rubigoRouter.push(Screens.s200),
      throwsA(
        predicate(
          (e) =>
              e is UnsupportedError &&
              e.message ==
                  'Developer: you may not Push or Pop in the willShow method.',
        ),
      ),
    );
  });

  test('Pop in willShow', () async {
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
        () => holder.get(S200ControllerWillShowPop.new),
      ),
      RubigoScreen(
        Screens.s300,
        S300Screen(),
        () => holder.get(S300Controller.new),
      ),
    ];
    final rubigoRouter = RubigoRouter<Screens>(
      splashScreenId: Screens.splashScreen,
      availableScreens: availableScreens,
    );
    await rubigoRouter.init(
      getFirstScreenAsync: () async => Screens.s100,
    );
    expect(
      () async => rubigoRouter.push(Screens.s200),
      throwsA(
        predicate(
          (e) =>
              e is UnsupportedError &&
              e.message ==
                  'Developer: you may not Push or Pop in the willShow method.',
        ),
      ),
    );
  });

  test('Pop in mayPop', () async {
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
        () => holder.get(S200ControllerMayPopPop.new),
      ),
    ];
    final rubigoRouter = RubigoRouter<Screens>(
      splashScreenId: Screens.splashScreen,
      availableScreens: availableScreens,
    );
    await rubigoRouter.init(
      getFirstScreenAsync: () async => Screens.s100,
    );
    await rubigoRouter.push(Screens.s200);
    expect(
      () async => rubigoRouter.pop(),
      throwsA(
        predicate(
          (e) =>
              e is UnsupportedError &&
              e.message ==
                  'Developer: you may not Push or Pop in the mayPop method.',
        ),
      ),
    );
  });

  test('Push in mayPop', () async {
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
        () => holder.get(S200ControllerMayPopPush.new),
      ),
    ];
    final rubigoRouter = RubigoRouter<Screens>(
      splashScreenId: Screens.splashScreen,
      availableScreens: availableScreens,
    );
    await rubigoRouter.init(
      getFirstScreenAsync: () async => Screens.s100,
    );
    await rubigoRouter.push(Screens.s200);
    expect(
      () async => rubigoRouter.pop(),
      throwsA(
        predicate(
          (e) =>
              e is UnsupportedError &&
              e.message ==
                  'Developer: you may not Push or Pop in the mayPop method.',
        ),
      ),
    );
  });

  test('Test s100-s200-s300 replaceStack s500-s600-s700', () async {
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
    final rubigoRouter = RubigoRouter<Screens>(
      splashScreenId: Screens.splashScreen,
      availableScreens: availableScreens,
    );
    await rubigoRouter.init(
      getFirstScreenAsync: () async => Screens.s100,
    );
    await rubigoRouter.push(Screens.s200);
    await rubigoRouter.push(Screens.s300);

    final expectedScreenWidgets1 = [
      Screens.s100,
      Screens.s200,
      Screens.s300,
    ].toListOfWidget(availableScreens);
    final actualPages1 = rubigoRouter.screens.toListOfMaterialPage();
    checkPages(
      actualPages: actualPages1,
      expectedScreenWidgets: expectedScreenWidgets1,
    );
    await rubigoRouter.replaceStack([
      Screens.s500,
      Screens.s600,
      Screens.s700,
    ]);
    final actualPages2 = rubigoRouter.screens.toListOfMaterialPage();
    final expectedScreenWidgets2 = [
      Screens.s500,
      Screens.s600,
      Screens.s700,
    ].toListOfWidget(availableScreens);
    checkPages(
      actualPages: actualPages2,
      expectedScreenWidgets: expectedScreenWidgets2,
    );
  });

  test('Test screens equals screenStackNotifier', () async {
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
    ];
    final rubigoRouter = RubigoRouter<Screens>(
      splashScreenId: Screens.splashScreen,
      availableScreens: availableScreens,
    );
    await rubigoRouter.init(
      getFirstScreenAsync: () async => Screens.s100,
    );
    await rubigoRouter.push(Screens.s200);
    await rubigoRouter.push(Screens.s300);

    final screens = rubigoRouter.screens.toListOfScreenId();
    final screenStack = rubigoRouter.screenStackNotifier.value;
    expect(screens.length, screenStack.length);
    for (var index = 0; index < screens.length; index++) {
      expect(screens[index], screenStack[index]);
    }
  });

  test('Test s100-s200 pop when mayPop returns false', () async {
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
        () => holder.get(S200ControllerMayPopReturnsFalse.new),
      ),
    ];
    final rubigoRouter = RubigoRouter<Screens>(
      splashScreenId: Screens.splashScreen,
      availableScreens: availableScreens,
    );
    await rubigoRouter.init(
      getFirstScreenAsync: () async => Screens.s100,
    );
    await rubigoRouter.push(Screens.s200);
    final actualPages = rubigoRouter.screens.toListOfMaterialPage();
    final expectedScreenWidgets1 = [
      Screens.s100,
      Screens.s200,
    ].toListOfWidget(availableScreens);
    checkPages(
      actualPages: actualPages,
      expectedScreenWidgets: expectedScreenWidgets1,
    );
    await rubigoRouter.pop();
    final actualPages2 = rubigoRouter.screens.toListOfMaterialPage();
    final expectedScreenWidgets2 = [
      Screens.s100,
      Screens.s200,
    ].toListOfWidget(availableScreens);
    checkPages(
      actualPages: actualPages2,
      expectedScreenWidgets: expectedScreenWidgets2,
    );
  });

  test('Test s100-s200-s300 hasScreenBelow and containsScreenBelow()',
      () async {
    final screens = [Screens.s100];
    expect(screens.hasScreenBelow(), false);
    expect(screens.containsScreenBelow(Screens.s200), false);
    screens.add(Screens.s200);
    expect(screens.hasScreenBelow(), true);
    expect(screens.containsScreenBelow(Screens.s200), false);
    screens.add(Screens.s300);
    expect(screens.hasScreenBelow(), true);
    expect(screens.containsScreenBelow(Screens.s200), true);
  });
}
