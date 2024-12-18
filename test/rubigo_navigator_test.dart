import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';
import 'package:rubigo_navigator/src/extensions/extensions.dart';

import 'helpers/helpers.dart';
import 'helpers/screens/s100/s100_controller.dart';
import 'helpers/screens/s100/s100_screen.dart';
import 'helpers/screens/s200/s200_controller.dart';
import 'helpers/screens/s200/s200_screen.dart';
import 'helpers/screens/s300/s200_controller.dart';
import 'helpers/screens/s300/s200_screen.dart';
import 'helpers/screens/screens.dart';
import 'helpers/unsupported_page.dart';

ListOfRubigoScreens<Screens> createAvailableScreens() => [
      RubigoScreen(Screens.s100, S100Screen(), S100Controller()),
      RubigoScreen(Screens.s200, S200Screen(), S200Controller()),
      RubigoScreen(Screens.s300, S300Screen(), S300Controller()),
    ];

void main() {
  test('Navigator with list of MaterialPages', () {
    final initialStack = [
      Screens.s100,
      Screens.s200,
      Screens.s300,
    ];
    final availableScreens = createAvailableScreens();
    final navigator = RubigoNavigator<Screens>(
      initialScreenStack: initialStack,
      availableScreens: availableScreens,
    );
    final pages = navigator.pages;
    final screens =
        initialStack.map((e) => availableScreens.findScreen(e)).toList();
    checkPages<MaterialPage<void>>(
      pages: pages,
      screens: screens,
    );
  });

  test('Navigator with list of CupertinoPages', () {
    final initialStack = [
      Screens.s100,
      Screens.s200,
      Screens.s300,
    ];
    final availableScreens = createAvailableScreens();
    final navigator = RubigoNavigator<Screens>(
      initialScreenStack: initialStack,
      availableScreens: availableScreens,
      screenToPage: (screen) => CupertinoPage<void>(child: screen),
    );
    final pages = navigator.pages;
    final screens =
        initialStack.map((e) => availableScreens.findScreen(e)).toList();
    checkPages<CupertinoPage<void>>(
      pages: pages,
      screens: screens,
    );
  });

  test('Navigator with list of UnsupportedPages', () {
    final initialStack = [
      Screens.s100,
      Screens.s200,
      Screens.s300,
    ];
    final availableScreens = createAvailableScreens();
    final navigator = RubigoNavigator<Screens>(
      initialScreenStack: initialStack,
      availableScreens: availableScreens,
      screenToPage: (screen) => UnsupportedPage<void>(child: screen),
    );
    expect(
      () => navigator.onDidRemovePage(
        UnsupportedPage<void>(
          child: S300Screen(),
        ),
      ),
      throwsA(
        predicate(
          (e) =>
              e is UnsupportedError &&
              e.message ==
                  'PANIC: Page must be of type MaterialPage or CupertinoPage',
        ),
      ),
    );
  });

  test('Test popTo', () async {
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
    final initialScreens =
        initialScreenStack.map(availableScreens.findScreen).toList();
    checkPages(
      pages: pages,
      screens: initialScreens,
    );
    await navigator.popTo(Screens.s100);
    final pages2 = navigator.pages;
    checkPages(
      pages: pages2,
      screens: [
        availableScreens.findScreen(Screens.s100),
      ],
    );
  });
}
