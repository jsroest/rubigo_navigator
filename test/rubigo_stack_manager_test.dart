import 'package:flutter_test/flutter_test.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';
import 'package:rubigo_navigator/src/flutter/screen_to_page_converters.dart';

import 'helpers/helpers.dart';
import 'helpers/screens/s100/s100_controller.dart';
import 'helpers/screens/s100/s100_screen.dart';
import 'helpers/screens/s200/s200_controller.dart';
import 'helpers/screens/s200/s200_controller_may_pop_pop.dart';
import 'helpers/screens/s200/s200_controller_may_pop_push.dart';
import 'helpers/screens/s200/s200_controller_on_top_push_and_pop.dart';
import 'helpers/screens/s200/s200_controller_will_show_pop.dart';
import 'helpers/screens/s200/s200_controller_will_show_push.dart';
import 'helpers/screens/s200/s200_screen.dart';
import 'helpers/screens/s300/s200_controller.dart';
import 'helpers/screens/s300/s200_screen.dart';
import 'helpers/screens/screens.dart';

ListOfRubigoScreens<Screens> createAvailableScreens() => [
      RubigoScreen(Screens.s100, S100Screen(), S100Controller()),
      RubigoScreen(Screens.s200, S200Screen(), S200Controller()),
      RubigoScreen(Screens.s300, S300Screen(), S300Controller()),
    ];

void main() {
  test('Test s100-s200-s300 pop', () async {
    final availableScreens = createAvailableScreens();
    final initialScreenStack = [
      Screens.s100,
      Screens.s200,
      Screens.s300,
    ];
    final rubigoRouter = RubigoRouter<Screens>(
      initialScreenStack: initialScreenStack,
      availableScreens: availableScreens,
    );

    final actualPages = rubigoRouter.screens.toMaterialPages();
    final expectedScreenWidgets =
        initialScreenStack.toListOfWidget(availableScreens);
    checkPages(
      actualPages: actualPages,
      expectedScreenWidgets: expectedScreenWidgets,
    );
    await rubigoRouter.pop();
    final actualPages2 = rubigoRouter.screens.toMaterialPages();
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
      final availableScreens = createAvailableScreens();
      final initialScreenStack = [
        Screens.s100,
      ];
      final rubigoRouter = RubigoRouter<Screens>(
        initialScreenStack: initialScreenStack,
        availableScreens: availableScreens,
      );
      final actualPages = rubigoRouter.screens.toMaterialPages();
      final expectedScreenWidgets =
          initialScreenStack.toListOfWidget(availableScreens);
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
    final availableScreens = createAvailableScreens();
    final initialScreenStack = [
      Screens.s100,
      Screens.s200,
      Screens.s300,
    ];
    final rubigoRouter = RubigoRouter<Screens>(
      initialScreenStack: initialScreenStack,
      availableScreens: availableScreens,
    );
    final actualPages = rubigoRouter.screens.toMaterialPages();
    final expectedScreenWidgets =
        initialScreenStack.toListOfWidget(availableScreens);
    checkPages(
      actualPages: actualPages,
      expectedScreenWidgets: expectedScreenWidgets,
    );
    await rubigoRouter.popTo(Screens.s100);
    final actualPages2 = rubigoRouter.screens.toMaterialPages();
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
      final availableScreens = createAvailableScreens();
      final initialScreenStack = [
        Screens.s100,
        Screens.s200,
      ];
      final rubigoRouter = RubigoRouter<Screens>(
        initialScreenStack: initialScreenStack,
        availableScreens: availableScreens,
      );
      final actualPages = rubigoRouter.screens.toMaterialPages();
      final expectedScreenWidgets =
          initialScreenStack.toListOfWidget(availableScreens);
      checkPages(
        actualPages: actualPages,
        expectedScreenWidgets: expectedScreenWidgets,
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
    final availableScreens = createAvailableScreens();
    final initialScreenStack = [
      Screens.s100,
    ];
    final rubigoRouter = RubigoRouter<Screens>(
      initialScreenStack: initialScreenStack,
      availableScreens: availableScreens,
    );
    final actualPages = rubigoRouter.screens.toMaterialPages();
    final expectedScreenWidgets =
        initialScreenStack.toListOfWidget(availableScreens);
    checkPages(
      actualPages: actualPages,
      expectedScreenWidgets: expectedScreenWidgets,
    );
    await rubigoRouter.push(Screens.s200);
    final actualPages2 = rubigoRouter.screens.toMaterialPages();
    final expectedScreenWidgets2 = [
      Screens.s100,
      Screens.s200,
    ].toListOfWidget(availableScreens);
    checkPages(
      actualPages: actualPages2,
      expectedScreenWidgets: expectedScreenWidgets2,
    );
  });

  test('Test s100-s200-s300 remove s200', () {
    final availableScreens = createAvailableScreens();
    final initialScreenStack = [
      Screens.s100,
      Screens.s200,
      Screens.s300,
    ];
    final rubigoRouter = RubigoRouter<Screens>(
      initialScreenStack: initialScreenStack,
      availableScreens: availableScreens,
    );
    final actualPages = rubigoRouter.screens.toMaterialPages();
    final expectedScreenWidgets =
        initialScreenStack.toListOfWidget(availableScreens);
    checkPages(
      actualPages: actualPages,
      expectedScreenWidgets: expectedScreenWidgets,
    );
    rubigoRouter.remove(Screens.s200);
    final actualPages2 = rubigoRouter.screens.toMaterialPages();
    final expectedScreenWidgets2 =
        [Screens.s100, Screens.s300].toListOfWidget(availableScreens);
    checkPages(
      actualPages: actualPages2,
      expectedScreenWidgets: expectedScreenWidgets2,
    );
  });

  test('Test s100-s200 remove s300', () {
    final availableScreens = createAvailableScreens();
    final initialScreenStack = [
      Screens.s100,
      Screens.s200,
    ];
    final rubigoRouter = RubigoRouter<Screens>(
      initialScreenStack: initialScreenStack,
      availableScreens: availableScreens,
    );
    final actualPages = rubigoRouter.screens.toMaterialPages();
    final expectedScreenWidgets =
        initialScreenStack.toListOfWidget(availableScreens);
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
    final availableScreens = [
      RubigoScreen(Screens.s100, S100Screen(), S100Controller()),
      RubigoScreen(Screens.s200, S200Screen(), S200ControllerOnTopPushAndPop()),
      RubigoScreen(Screens.s300, S300Screen(), S300Controller()),
    ];
    final initialScreenStack = [
      Screens.s100,
    ];
    final rubigoRouter = RubigoRouter<Screens>(
      initialScreenStack: initialScreenStack,
      availableScreens: availableScreens,
    );
    await rubigoRouter.push(Screens.s200);
    final actualPages = rubigoRouter.screens.toMaterialPages();
    final expectedScreenWidgets = [
      Screens.s100,
      Screens.s200,
      Screens.s300,
    ].toListOfWidget(availableScreens);
    checkPages(
      actualPages: actualPages,
      expectedScreenWidgets: expectedScreenWidgets,
    );
  });

  test('Test s100-s200-s300 pop s100', () async {
    final availableScreens = [
      RubigoScreen(Screens.s100, S100Screen(), S100Controller()),
      RubigoScreen(Screens.s200, S200Screen(), S200ControllerOnTopPushAndPop()),
      RubigoScreen(Screens.s300, S300Screen(), S300Controller()),
    ];
    final initialScreenStack = [
      Screens.s100,
      Screens.s200,
      Screens.s300,
    ];
    final rubigoRouter = RubigoRouter<Screens>(
      initialScreenStack: initialScreenStack,
      availableScreens: availableScreens,
    );
    await rubigoRouter.pop();
    final actualPages = rubigoRouter.screens.toMaterialPages();
    final expectedScreenWidgets = [
      Screens.s100,
    ].toListOfWidget(availableScreens);
    checkPages(
      actualPages: actualPages,
      expectedScreenWidgets: expectedScreenWidgets,
    );
  });

  test('Push in willShow', () async {
    final availableScreens = [
      RubigoScreen(Screens.s100, S100Screen(), S100Controller()),
      RubigoScreen(Screens.s200, S200Screen(), S200ControllerWillShowPush()),
      RubigoScreen(Screens.s300, S300Screen(), S300Controller()),
    ];
    final initialScreenStack = [
      Screens.s100,
    ];
    final rubigoRouter = RubigoRouter<Screens>(
      initialScreenStack: initialScreenStack,
      availableScreens: availableScreens,
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
    final availableScreens = [
      RubigoScreen(Screens.s100, S100Screen(), S100Controller()),
      RubigoScreen(
        Screens.s200,
        S200Screen(),
        S200ControllerWillShowPop(),
      ),
      RubigoScreen(Screens.s300, S300Screen(), S300Controller()),
    ];
    final initialScreenStack = [
      Screens.s100,
      Screens.s200,
      Screens.s300,
    ];
    final rubigoRouter = RubigoRouter<Screens>(
      initialScreenStack: initialScreenStack,
      availableScreens: availableScreens,
    );
    expect(
      () async => rubigoRouter.pop(),
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
    final availableScreens = [
      RubigoScreen(Screens.s100, S100Screen(), S100Controller()),
      RubigoScreen(
        Screens.s200,
        S200Screen(),
        S200ControllerMayPopPop(),
      ),
    ];
    final initialScreenStack = [
      Screens.s100,
      Screens.s200,
    ];
    final rubigoRouter = RubigoRouter<Screens>(
      initialScreenStack: initialScreenStack,
      availableScreens: availableScreens,
    );
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
    final availableScreens = [
      RubigoScreen(Screens.s100, S100Screen(), S100Controller()),
      RubigoScreen(
        Screens.s200,
        S200Screen(),
        S200ControllerMayPopPush(),
      ),
    ];
    final initialScreenStack = [
      Screens.s100,
      Screens.s200,
    ];
    final rubigoRouter = RubigoRouter<Screens>(
      initialScreenStack: initialScreenStack,
      availableScreens: availableScreens,
    );
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
}
