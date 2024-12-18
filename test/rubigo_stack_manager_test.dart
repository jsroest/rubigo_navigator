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

ListOfRubigoScreens<Screens> createAvailableScreens() => [
      RubigoScreen(Screens.s100, S100Screen(), S100Controller()),
      RubigoScreen(Screens.s200, S200Screen(), S200Controller()),
      RubigoScreen(Screens.s300, S300Screen(), S300Controller()),
    ];

void main() {
  test('Test pop', () async {
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

  test('Test push', () async {
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
}
