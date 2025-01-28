import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rubigo_router/rubigo_router.dart';

import 'screens/s100/s100_controller.dart';
import 'screens/s100/s100_screen.dart';
import 'screens/s200/s200_screen.dart';
import 'screens/s300/s300_controller.dart';
import 'screens/s300/s300_screen.dart';
import 'screens/screens.dart';

void main() {
  late RubigoHolder holder;
  setUp(
    () {
      holder = RubigoHolder();
    },
  );

  test(
    'find(screenId)',
    () {
      final availableScreens = [
        RubigoScreen(
          Screens.s100,
          S100Screen(),
          () => holder.getOrCreate(S100Controller.new),
        ),
        RubigoScreen(
          Screens.s200,
          S200Screen(),
          () => holder.getOrCreate(S100Controller.new),
        ),
        RubigoScreen(
          Screens.s300,
          S300Screen(),
          () => holder.getOrCreate(S300Controller.new),
        ),
      ];

      expect(availableScreens[0], availableScreens.find(Screens.s100));
      expect(availableScreens[1], availableScreens.find(Screens.s200));
      expect(availableScreens[2], availableScreens.find(Screens.s300));
    },
  );

  test(
    'toListOfScreenId',
    () {
      final availableScreens = [
        RubigoScreen(
          Screens.s100,
          S100Screen(),
          () => holder.getOrCreate(S100Controller.new),
        ),
        RubigoScreen(
          Screens.s200,
          S200Screen(),
          () => holder.getOrCreate(S100Controller.new),
        ),
        RubigoScreen(
          Screens.s300,
          S300Screen(),
          () => holder.getOrCreate(S300Controller.new),
        ),
      ];
      final listOfScreenId = availableScreens.toListOfScreenId();
      expect(availableScreens[0].screenId, listOfScreenId[0]);
      expect(availableScreens[1].screenId, listOfScreenId[1]);
      expect(availableScreens[2].screenId, listOfScreenId[2]);
    },
  );

  test(
    'toListOfWidget',
    () {
      final availableScreens = [
        RubigoScreen(
          Screens.s100,
          S100Screen(),
          () => holder.getOrCreate(S100Controller.new),
        ),
        RubigoScreen(
          Screens.s200,
          S200Screen(),
          () => holder.getOrCreate(S100Controller.new),
        ),
        RubigoScreen(
          Screens.s300,
          S300Screen(),
          () => holder.getOrCreate(S300Controller.new),
        ),
      ];
      final listOfWidget = availableScreens.toListOfWidget();
      expect(availableScreens[0].screenWidget, listOfWidget[0]);
      expect(availableScreens[1].screenWidget, listOfWidget[1]);
      expect(availableScreens[2].screenWidget, listOfWidget[2]);
    },
  );

  test(
    'hasScreenBelow',
    () {
      const topPage = Screens.s100;
      final stack = [
        Screens.s200,
        topPage,
      ];
      expect(stack.hasScreenBelow(), true);
      stack.remove(Screens.s200);
      expect(stack.hasScreenBelow(), false);
    },
  );

  test(
    'containsScreenBelow',
    () {
      const topPage = Screens.s100;
      final stack = [
        Screens.s200,
        topPage,
      ];
      expect(stack.containsScreenBelow(Screens.s300), false);
      expect(stack.containsScreenBelow(Screens.s200), true);
      expect(stack.containsScreenBelow(Screens.s100), false);
    },
  );

  test(
    'toListOfRubigoScreen',
    () {
      final availableScreens = [
        RubigoScreen(
          Screens.s100,
          S100Screen(),
          () => holder.getOrCreate(S100Controller.new),
        ),
        RubigoScreen(
          Screens.s200,
          S200Screen(),
          () => holder.getOrCreate(S100Controller.new),
        ),
        RubigoScreen(
          Screens.s300,
          S300Screen(),
          () => holder.getOrCreate(S300Controller.new),
        ),
      ];
      final list1 = [
        availableScreens.find(Screens.s100),
        availableScreens.find(Screens.s200),
      ];
      final stack = [Screens.s100, Screens.s200];
      final list2 = stack.toListOfRubigoScreen(availableScreens);
      expect(listEquals(list1, list2), true);
    },
  );

  test(
    'Breadcrumbs',
    () {
      final stack = [Screens.s100, Screens.s200];
      final breadCrumbs = stack.breadCrumbs();
      expect(breadCrumbs, 'S100→S200');
    },
  );

  test(
    'MaterialPage',
    () {
      final s100 = RubigoScreen(
        Screens.s100,
        Container(),
        () => holder.getOrCreate(S100Controller.new),
      );
      final materialPage = s100.toMaterialPage();
      expect(materialPage.key, s100.pageKey);
      expect(materialPage.child, s100.screenWidget);
    },
  );

  test(
    'CupertinoPage',
    () {
      final s100 = RubigoScreen(
        Screens.s100,
        Container(),
        () => holder.getOrCreate(S100Controller.new),
      );
      final cupertinoPage = s100.toCupertinoPage();
      expect(cupertinoPage.key, s100.pageKey);
      expect(cupertinoPage.child, s100.screenWidget);
    },
  );
}
