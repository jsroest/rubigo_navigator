import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';

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
    final screens = initialStack.map(availableScreens.findScreen).toList();
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
      screenListToPageList: (screenList) =>
          screenList.map((e) => CupertinoPage<void>(child: e)).toList(),
    );
    final pages = navigator.pages;
    final screens = initialStack.map(availableScreens.findScreen).toList();
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
      screenListToPageList: (screenList) =>
          screenList.map((e) => UnsupportedPage<void>(child: e)).toList(),
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
                  'PANIC: Page must be of type MaterialPage or CupertinoPage.',
        ),
      ),
    );
  });

  test('onDidRemovePage last MaterialPage', () async {
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
    await navigator.onDidRemovePage(
      MaterialPage<void>(
        child: availableScreens[2].screenWidget,
      ),
    );
    checkPages(
      pages: navigator.pages,
      screens: [
        availableScreens[0].screenWidget,
        availableScreens[1].screenWidget,
      ],
    );
  });

  test('onDidRemovePage last CupertinoPage', () async {
    final initialStack = [
      Screens.s100,
      Screens.s200,
      Screens.s300,
    ];
    final availableScreens = createAvailableScreens();
    final navigator = RubigoNavigator<Screens>(
      initialScreenStack: initialStack,
      availableScreens: availableScreens,
      screenListToPageList: (screenList) =>
          screenList.map((e) => CupertinoPage<void>(child: e)).toList(),
    );
    await navigator.onDidRemovePage(
      CupertinoPage<void>(
        child: availableScreens[2].screenWidget,
      ),
    );
    checkPages(
      pages: navigator.pages,
      screens: [
        availableScreens[0].screenWidget,
        availableScreens[1].screenWidget,
      ],
    );
  });

  test('onDidRemovePage middle MaterialPage', () async {
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
    await navigator.onDidRemovePage(
      MaterialPage<void>(
        child: availableScreens[1].screenWidget,
      ),
    );
    checkPages(
      pages: navigator.pages,
      screens: [
        availableScreens[0].screenWidget,
        availableScreens[1].screenWidget,
        availableScreens[2].screenWidget,
      ],
    );
  });

  test('onPopPage last page', () async {
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
    await navigator.onPopPage(
      MaterialPageRoute<void>(builder: (_) => const Placeholder()),
      null,
    );
    checkPages(
      pages: navigator.pages,
      screens: [
        availableScreens[0].screenWidget,
        availableScreens[1].screenWidget,
      ],
    );
  });
}
