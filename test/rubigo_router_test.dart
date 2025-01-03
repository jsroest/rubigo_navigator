import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';
import 'package:rubigo_navigator/src/flutter/screen_to_page_converters.dart';

import 'helpers/helpers.dart';
import 'helpers/screens/s100/s100_controller.dart';
import 'helpers/screens/s100/s100_screen.dart';
import 'helpers/screens/s200/s200_controller.dart';
import 'helpers/screens/s200/s200_screen.dart';
import 'helpers/screens/s300/s300_controller.dart';
import 'helpers/screens/s300/s300_screen.dart';
import 'helpers/screens/screens.dart';
import 'helpers/screens/splash_screen/splash_controller.dart';
import 'helpers/screens/splash_screen/splash_screen.dart';
import 'helpers/unsupported_page.dart';

List<RubigoScreen<Screens>> get createAvailableScreens => [
      RubigoScreen(Screens.splashScreen, SplashScreen(), SplashController()),
      RubigoScreen(Screens.s100, S100Screen(), S100Controller()),
      RubigoScreen(Screens.s200, S200Screen(), S200Controller()),
      RubigoScreen(Screens.s300, S300Screen(), S300Controller()),
    ];

void main() {
  test('Navigator with list of MaterialPages', () async {
    final availableScreens = createAvailableScreens;
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

  test('Navigator with list of CupertinoPages', () async {
    final availableScreens = createAvailableScreens;
    final rubigoRouter = RubigoRouter<Screens>(
      splashScreenId: Screens.splashScreen,
      availableScreens: availableScreens,
    );
    await rubigoRouter.init(
      getFirstScreenAsync: () async => Screens.s100,
    );
    await rubigoRouter.push(Screens.s200);
    await rubigoRouter.push(Screens.s300);
    final actualPages = rubigoRouter.screens.toListOfCupertinoPage();
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

  test('Navigator with list of UnsupportedPages', () async {
    final availableScreens = createAvailableScreens;
    final rubigoRouter = RubigoRouter<Screens>(
      splashScreenId: Screens.splashScreen,
      availableScreens: availableScreens,
    );
    await rubigoRouter.init(
      getFirstScreenAsync: () async => Screens.s100,
    );
    await rubigoRouter.push(Screens.s200);
    await rubigoRouter.push(Screens.s300);
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
    final availableScreens = createAvailableScreens;
    final rubigoRouter = RubigoRouter<Screens>(
      splashScreenId: Screens.splashScreen,
      availableScreens: availableScreens,
    );
    await rubigoRouter.init(
      getFirstScreenAsync: () async => Screens.s100,
    );
    await rubigoRouter.push(Screens.s200);
    await rubigoRouter.push(Screens.s300);
    await rubigoRouter.onDidRemovePage(
      MaterialPage<void>(
        key: availableScreens[3].pageKey,
        child: availableScreens[3].screenWidget,
      ),
    );
    final actualPages = rubigoRouter.screens.toListOfMaterialPage();
    final expectedScreenWidgets = [
      availableScreens[1].screenWidget,
      availableScreens[2].screenWidget,
    ];
    checkPages(
      actualPages: actualPages,
      expectedScreenWidgets: expectedScreenWidgets,
    );
  });

  test('onDidRemovePage last CupertinoPage', () async {
    final availableScreens = createAvailableScreens;
    final rubigoRouter = RubigoRouter<Screens>(
      splashScreenId: Screens.splashScreen,
      availableScreens: availableScreens,
    );
    await rubigoRouter.init(
      getFirstScreenAsync: () async => Screens.s100,
    );
    await rubigoRouter.push(Screens.s200);
    await rubigoRouter.push(Screens.s300);
    await rubigoRouter.onDidRemovePage(
      CupertinoPage<void>(
        key: availableScreens[3].pageKey,
        child: availableScreens[3].screenWidget,
      ),
    );
    final actualPages = rubigoRouter.screens.toListOfCupertinoPage();
    final expectedScreenWidgets = [
      availableScreens[1].screenWidget,
      availableScreens[2].screenWidget,
    ];
    checkPages(
      actualPages: actualPages,
      expectedScreenWidgets: expectedScreenWidgets,
    );
  });

  test('onDidRemovePage middle MaterialPage', () async {
    final availableScreens = createAvailableScreens;
    final rubigoRouter = RubigoRouter<Screens>(
      splashScreenId: Screens.splashScreen,
      availableScreens: availableScreens,
    );
    await rubigoRouter.init(
      getFirstScreenAsync: () async => Screens.s100,
    );
    await rubigoRouter.push(Screens.s200);
    await rubigoRouter.push(Screens.s300);
    await rubigoRouter.onDidRemovePage(
      MaterialPage<void>(
        key: availableScreens[2].pageKey,
        child: availableScreens[2].screenWidget,
      ),
    );
    final actualPages = rubigoRouter.screens.toListOfMaterialPage();
    final expectedScreenWidgets = [
      availableScreens[1].screenWidget,
      availableScreens[2].screenWidget,
      availableScreens[3].screenWidget,
    ];
    checkPages(
      actualPages: actualPages,
      expectedScreenWidgets: expectedScreenWidgets,
    );
  });

  test('onPopPage last page', () async {
    final availableScreens = createAvailableScreens;
    final rubigoRouter = RubigoRouter<Screens>(
      splashScreenId: Screens.splashScreen,
      availableScreens: availableScreens,
    );
    await rubigoRouter.init(
      getFirstScreenAsync: () async => Screens.s100,
    );
    await rubigoRouter.push(Screens.s200);
    await rubigoRouter.push(Screens.s300);
    rubigoRouter.onPopPage(
      MaterialPageRoute<void>(builder: (_) => const Placeholder()),
      null,
    );
    //Allow time for the pop to finish.
    await Future<void>.delayed(const Duration(milliseconds: 10));
    final actualPages = rubigoRouter.screens.toListOfMaterialPage();
    final expectedScreenWidgets = [
      availableScreens[1].screenWidget,
      availableScreens[2].screenWidget,
    ];
    checkPages(
      actualPages: actualPages,
      expectedScreenWidgets: expectedScreenWidgets,
    );
  });
}
