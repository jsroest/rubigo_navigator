import 'package:flutter_test/flutter_test.dart';
import 'package:rubigo_router/src/extensions/extensions.dart';
import 'package:rubigo_router/src/rubigo_holder.dart';
import 'package:rubigo_router/src/rubigo_router.dart';
import 'package:rubigo_router/src/rubigo_screen.dart';

import 'helpers/extensions.dart';
import 'helpers/helpers.dart';
import 'helpers/rubigo_screen_creators.dart';
import 'helpers/screens/screens.dart';

void main() {
  late RubigoHolder holder;
  late List<RubigoScreen<Screens>> availableScreens;
  late RubigoRouter<Screens> rubigoRouter;

  setUp(
    () async {
      holder = RubigoHolder();
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
    final actualPages = rubigoRouter.screens.value.toListOfMaterialPage();
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
    final actualPages = rubigoRouter.screens.value.toListOfCupertinoPage();
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
}
