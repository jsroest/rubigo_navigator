import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rubigo_navigator/src/extensions/extensions.dart';
import 'package:rubigo_navigator/src/flutter/screen_to_page_converters.dart';
import 'package:rubigo_navigator/src/rubigo_controller_holder.dart';
import 'package:rubigo_navigator/src/rubigo_router.dart';
import 'package:rubigo_navigator/src/rubigo_screen.dart';

import 'helpers/extensions.dart';
import 'helpers/helpers.dart';
import 'helpers/rubigo_screen_creators.dart';
import 'helpers/screens/mocks/mock_controller.dart';
import 'helpers/screens/s300/s300_screen.dart';
import 'helpers/screens/screens.dart';
import 'helpers/unsupported_page.dart';

void main() {
  late RubigoControllerHolder<MockController<Screens>> holder;
  late List<RubigoScreen<Screens>> availableScreens;
  late RubigoRouter<Screens> rubigoRouter;

  setUp(
    () async {
      holder = RubigoControllerHolder<MockController<Screens>>();
      availableScreens = [
        getSplashScreen(holder),
        getS100Screen(holder),
        getS200Screen(holder),
        getS300Screen(holder),
      ];
      rubigoRouter = RubigoRouter<Screens>(
        splashScreenId: Screens.splashScreen,
        availableScreens: availableScreens,
      );
      await rubigoRouter.init(
        initAndGetFirstScreen: () async => Screens.s100,
      );
      await rubigoRouter.push(Screens.s200);
      await rubigoRouter.push(Screens.s300);
    },
  );

  test('Router with list of MaterialPages', () async {
    final actualPages = rubigoRouter.screens.toListOfMaterialPage();
    final expectedScreenWidgets = [
      availableScreens[1],
      availableScreens[2],
      availableScreens[3],
    ].toListOfWidget();
    checkPages(
      actualPages: actualPages,
      expectedScreenWidgets: expectedScreenWidgets,
    );
  });

  test('Router with list of CupertinoPages', () async {
    final actualPages = rubigoRouter.screens.toListOfCupertinoPage();
    final expectedScreenWidgets = [
      availableScreens[1],
      availableScreens[2],
      availableScreens[3],
    ].toListOfWidget();
    checkPages(
      actualPages: actualPages,
      expectedScreenWidgets: expectedScreenWidgets,
    );
  });

  test('Router with list of UnsupportedPages', () async {
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

  test('onDidRemovePage top MaterialPage', () async {
    await rubigoRouter.onDidRemovePage(
      MaterialPage<void>(
        key: availableScreens[3].pageKey,
        child: availableScreens[3].screenWidget,
      ),
    );
    final actualPages = rubigoRouter.screens.toListOfMaterialPage();
    final expectedScreenWidgets = [
      availableScreens[1],
      availableScreens[2],
    ].toListOfWidget();
    checkPages(
      actualPages: actualPages,
      expectedScreenWidgets: expectedScreenWidgets,
    );
  });

  test('onDidRemovePage top CupertinoPage', () async {
    await rubigoRouter.onDidRemovePage(
      CupertinoPage<void>(
        key: availableScreens[3].pageKey,
        child: availableScreens[3].screenWidget,
      ),
    );
    final actualPages = rubigoRouter.screens.toListOfCupertinoPage();
    final expectedScreenWidgets = [
      availableScreens[1],
      availableScreens[2],
    ].toListOfWidget();
    checkPages(
      actualPages: actualPages,
      expectedScreenWidgets: expectedScreenWidgets,
    );
  });

  test('onDidRemovePage middle MaterialPage', () async {
    await rubigoRouter.onDidRemovePage(
      MaterialPage<void>(
        key: availableScreens[2].pageKey,
        child: availableScreens[2].screenWidget,
      ),
    );
    final actualPages = rubigoRouter.screens.toListOfMaterialPage();
    final expectedScreenWidgets = [
      availableScreens[1],
      availableScreens[2],
      availableScreens[3],
    ].toListOfWidget();
    checkPages(
      actualPages: actualPages,
      expectedScreenWidgets: expectedScreenWidgets,
    );
  });

  test('onPopPage top page', () async {
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
