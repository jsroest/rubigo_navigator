import 'package:flutter_test/flutter_test.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';

import 'helpers/helpers.dart';
import 'helpers/screens/s100/s100_controller.dart';
import 'helpers/screens/s100/s100_screen.dart';
import 'helpers/screens/s200/s200_controller.dart';
import 'helpers/screens/s200/s200_controller_with_on_top_event.dart';
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
    final navigator = RubigoNavigator<Screens>(
      initialScreenStack: initialScreenStack,
      availableScreens: availableScreens,
    );
    final pages = navigator.pages;
    final initialScreens = initialScreenStack.toListOfWidget(availableScreens);

    checkPages(
      pages: pages,
      screens: initialScreens,
    );
    await navigator.pop();
    final pages2 = navigator.pages;
    final screens2 = [
      Screens.s100,
      Screens.s200,
    ].toListOfWidget(availableScreens);

    checkPages(
      pages: pages2,
      screens: screens2,
    );
  });

  test(
    'Test s100 pop',
    () async {
      final availableScreens = createAvailableScreens();
      final initialScreenStack = [
        Screens.s100,
      ];
      final navigator = RubigoNavigator<Screens>(
        initialScreenStack: initialScreenStack,
        availableScreens: availableScreens,
      );
      final pages = navigator.pages;
      final initialScreens =
          initialScreenStack.toListOfWidget(availableScreens);

      checkPages(
        pages: pages,
        screens: initialScreens,
      );

      expect(
        () async => await navigator.pop(),
        throwsA(
          predicate(
            (e) =>
                e is UnsupportedError &&
                e.message ==
                    'Developer: Pop was called on the last page. The screen stack may not be empty',
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
    final navigator = RubigoNavigator<Screens>(
      initialScreenStack: initialScreenStack,
      availableScreens: availableScreens,
    );
    final pages = navigator.pages;
    final screens = initialScreenStack.toListOfWidget(availableScreens);
    checkPages(
      pages: pages,
      screens: screens,
    );
    await navigator.popTo(Screens.s100);
    final pages2 = navigator.pages;
    final screens2 = [Screens.s100].toListOfWidget(availableScreens);
    checkPages(
      pages: pages2,
      screens: screens2,
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
      final navigator = RubigoNavigator<Screens>(
        initialScreenStack: initialScreenStack,
        availableScreens: availableScreens,
      );
      final pages = navigator.pages;
      final initialScreens =
          initialScreenStack.toListOfWidget(availableScreens);

      checkPages(
        pages: pages,
        screens: initialScreens,
      );

      expect(
        () async => await navigator.popTo(Screens.s300),
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
    final navigator = RubigoNavigator<Screens>(
      initialScreenStack: initialScreenStack,
      availableScreens: availableScreens,
    );
    final pages = navigator.pages;
    final initialScreens =
        initialScreenStack.map(availableScreens.findScreen).toList();
    checkPages(
      pages: pages,
      screens: initialScreens,
    );
    await navigator.push(Screens.s200);
    final pages2 = navigator.pages;
    final screens2 = [
      Screens.s100,
      Screens.s200,
    ].toListOfWidget(availableScreens);
    checkPages(
      pages: pages2,
      screens: screens2,
    );
  });

  test('Test s100-s200-s300 remove s200', () {
    final availableScreens = createAvailableScreens();
    final initialScreenStack = [
      Screens.s100,
      Screens.s200,
      Screens.s300,
    ];
    final navigator = RubigoNavigator<Screens>(
      initialScreenStack: initialScreenStack,
      availableScreens: availableScreens,
    );
    final pages = navigator.pages;
    final screens = initialScreenStack.toListOfWidget(availableScreens);
    checkPages(
      pages: pages,
      screens: screens,
    );
    navigator.remove(Screens.s200);
    final pages2 = navigator.pages;
    final screens2 =
        [Screens.s100, Screens.s300].toListOfWidget(availableScreens);
    checkPages(
      pages: pages2,
      screens: screens2,
    );
  });

  test('Test s100-s200 remove s300', () {
    final availableScreens = createAvailableScreens();
    final initialScreenStack = [
      Screens.s100,
      Screens.s200,
    ];
    final navigator = RubigoNavigator<Screens>(
      initialScreenStack: initialScreenStack,
      availableScreens: availableScreens,
    );
    final pages = navigator.pages;
    final screens = initialScreenStack.toListOfWidget(availableScreens);
    checkPages(
      pages: pages,
      screens: screens,
    );

    expect(
      () => navigator.remove(Screens.s300),
      throwsA(
        predicate(
          (e) =>
              e is UnsupportedError &&
              e.message ==
                  'Developer: You can only remove pages that exist on the stack (s300 not found).',
        ),
      ),
    );
  });

  test('Test s100 push s100-s200-s300', () async {
    final availableScreens = [
      RubigoScreen(Screens.s100, S100Screen(), S100Controller()),
      RubigoScreen(Screens.s200, S200Screen(), S200ControllerWithOnTopEvents()),
      RubigoScreen(Screens.s300, S300Screen(), S300Controller()),
    ];
    final initialScreenStack = [
      Screens.s100,
    ];
    final navigator = RubigoNavigator<Screens>(
      initialScreenStack: initialScreenStack,
      availableScreens: availableScreens,
    );
    await navigator.push(Screens.s200);
    final pages = navigator.pages;
    final screens = [
      Screens.s100,
      Screens.s200,
      Screens.s300,
    ].toListOfWidget(availableScreens);
    checkPages(
      pages: pages,
      screens: screens,
    );
  });

  test('Test s100-s200-s300 pop s100 ', () async {
    final availableScreens = [
      RubigoScreen(Screens.s100, S100Screen(), S100Controller()),
      RubigoScreen(Screens.s200, S200Screen(), S200ControllerWithOnTopEvents()),
      RubigoScreen(Screens.s300, S300Screen(), S300Controller()),
    ];
    final initialScreenStack = [
      Screens.s100,
      Screens.s200,
      Screens.s300,
    ];
    final navigator = RubigoNavigator<Screens>(
      initialScreenStack: initialScreenStack,
      availableScreens: availableScreens,
    );
    await navigator.pop();
    final pages = navigator.pages;
    final screens = [
      Screens.s100,
    ].toListOfWidget(availableScreens);
    checkPages(
      pages: pages,
      screens: screens,
    );
  });
}
