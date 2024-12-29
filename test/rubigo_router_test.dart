import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';
import 'package:rubigo_navigator/src/flutter/screen_to_page_converters.dart';

import 'helpers/helpers.dart';
import 'helpers/rubigo_router.dart';
import 'helpers/screens/s100/s100_controller.dart';
import 'helpers/screens/s100/s100_screen.dart';
import 'helpers/screens/s200/s200_controller.dart';
import 'helpers/screens/s200/s200_screen.dart';
import 'helpers/screens/s300/s300_controller.dart';
import 'helpers/screens/s300/s300_screen.dart';
import 'helpers/screens/screens.dart';
import 'helpers/unsupported_page.dart';

ListOfRubigoScreens<Screens> createAvailableScreens() => [
      RubigoScreen(Screens.s100, S100Screen(), S100Controller()),
      RubigoScreen(Screens.s200, S200Screen(), S200Controller()),
      RubigoScreen(Screens.s300, S300Screen(), S300Controller()),
    ];

void main() {
  setUpAll(
    () {
      GetIt.instance.registerSingleton(RubigoRouter<Screens>());
    },
  );

  test('Navigator with list of MaterialPages', () {
    final initialScreenStack = [
      Screens.s100,
      Screens.s200,
      Screens.s300,
    ];
    final availableScreens = createAvailableScreens();
    rubigoRouter.init(
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
  });

  test('Navigator with list of CupertinoPages', () {
    final initialScreenStack = [
      Screens.s100,
      Screens.s200,
      Screens.s300,
    ];
    final availableScreens = createAvailableScreens();
    rubigoRouter.init(
      initialScreenStack: initialScreenStack,
      availableScreens: availableScreens,
    );
    final actualPages = rubigoRouter.screens.toCupertinoPages();
    final expectedScreenWidgets =
        initialScreenStack.toListOfWidget(availableScreens);
    checkPages(
      actualPages: actualPages,
      expectedScreenWidgets: expectedScreenWidgets,
    );
  });

  test('Navigator with list of UnsupportedPages', () async {
    final initialScreenStack = [
      Screens.s100,
      Screens.s200,
      Screens.s300,
    ];
    final availableScreens = createAvailableScreens();
    rubigoRouter.init(
      initialScreenStack: initialScreenStack,
      availableScreens: availableScreens,
    );
    await expectLater(
      () => rubigoRouter.onDidRemovePage(
        UnsupportedPage<void>(
          child: S300Screen(),
        ),
      ),
      throwsA(
        predicate(
          (e) =>
              e is UnsupportedError &&
              e.message == 'PANIC: page.key must be of type ValueKey<Screens>.',
        ),
      ),
    );
  });

  test('onDidRemovePage last MaterialPage', () async {
    final initialScreenStack = [
      Screens.s100,
      Screens.s200,
      Screens.s300,
    ];
    final availableScreens = createAvailableScreens();
    rubigoRouter.init(
      initialScreenStack: initialScreenStack,
      availableScreens: availableScreens,
    );
    await rubigoRouter.onDidRemovePage(
      MaterialPage<void>(
        key: availableScreens[2].pageKey,
        child: availableScreens[2].screenWidget,
      ),
    );
    final actualPages = rubigoRouter.screens.toMaterialPages();
    final expectedScreenWidgets = [
      availableScreens[0].screenWidget,
      availableScreens[1].screenWidget,
    ];
    checkPages(
      actualPages: actualPages,
      expectedScreenWidgets: expectedScreenWidgets,
    );
  });

  test('onDidRemovePage last CupertinoPage', () async {
    final initialScreenStack = [
      Screens.s100,
      Screens.s200,
      Screens.s300,
    ];
    final availableScreens = createAvailableScreens();
    rubigoRouter.init(
      initialScreenStack: initialScreenStack,
      availableScreens: availableScreens,
    );
    await rubigoRouter.onDidRemovePage(
      CupertinoPage<void>(
        key: availableScreens[2].pageKey,
        child: availableScreens[2].screenWidget,
      ),
    );
    final actualPages = rubigoRouter.screens.toCupertinoPages();
    final expectedScreenWidgets = [
      availableScreens[0].screenWidget,
      availableScreens[1].screenWidget,
    ];
    checkPages(
      actualPages: actualPages,
      expectedScreenWidgets: expectedScreenWidgets,
    );
  });

  test('onDidRemovePage middle MaterialPage', () async {
    final initialScreenStack = [
      Screens.s100,
      Screens.s200,
      Screens.s300,
    ];
    final availableScreens = createAvailableScreens();
    rubigoRouter.init(
      initialScreenStack: initialScreenStack,
      availableScreens: availableScreens,
    );
    await rubigoRouter.onDidRemovePage(
      MaterialPage<void>(
        key: availableScreens[1].pageKey,
        child: availableScreens[1].screenWidget,
      ),
    );
    final actualPages = rubigoRouter.screens.toMaterialPages();
    final expectedScreenWidgets = [
      availableScreens[0].screenWidget,
      availableScreens[1].screenWidget,
      availableScreens[2].screenWidget,
    ];
    checkPages(
      actualPages: actualPages,
      expectedScreenWidgets: expectedScreenWidgets,
    );
  });

  test('onPopPage last page', () async {
    final initialScreenStack = [
      Screens.s100,
      Screens.s200,
      Screens.s300,
    ];
    final availableScreens = createAvailableScreens();
    rubigoRouter.init(
      initialScreenStack: initialScreenStack,
      availableScreens: availableScreens,
    );
    rubigoRouter.onPopPage(
      MaterialPageRoute<void>(builder: (_) => const Placeholder()),
      null,
    );
    //Allow time for the pop to finish.
    await Future<void>.delayed(const Duration(milliseconds: 10));
    final actualPages = rubigoRouter.screens.toMaterialPages();
    final expectedScreenWidgets = [
      availableScreens[0].screenWidget,
      availableScreens[1].screenWidget,
    ];
    checkPages(
      actualPages: actualPages,
      expectedScreenWidgets: expectedScreenWidgets,
    );
  });
}
