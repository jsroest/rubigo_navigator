import 'package:flutter_test/flutter_test.dart';
import 'package:rubigo_router/rubigo_router.dart';

import 'screens/s100/s100_controller.dart';
import 'screens/s100/s100_screen.dart';
import 'screens/s200/s200_controller.dart';
import 'screens/s200/s200_screen.dart';
import 'screens/s300/s300_controller.dart';
import 'screens/s300/s300_screen.dart';
import 'screens/screens.dart';
import 'screens/splash_screen/splash_controller.dart';
import 'screens/splash_screen/splash_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late RubigoHolder holder;
  late List<RubigoScreen<Screens>> availableScreens;
  late RubigoRouter<Screens> rubigoRouter;

  setUp(() async {
    holder = RubigoHolder();
    availableScreens = [
      RubigoScreen(
        Screens.splashScreen,
        SplashScreen(),
        () => holder.getOrCreate(SplashController.new),
      ),
      RubigoScreen(
        Screens.s100,
        S100Screen(),
        () => holder.getOrCreate(S100Controller.new),
      ),
      RubigoScreen(
        Screens.s200,
        S200Screen(),
        () => holder.getOrCreate(S200Controller.new),
      ),
      RubigoScreen(
        Screens.s300,
        S300Screen(),
        () => holder.getOrCreate(S300Controller.new),
      ),
    ];
    rubigoRouter = RubigoRouter(
      availableScreens: availableScreens,
      splashScreenId: Screens.splashScreen,
    );
    await rubigoRouter.init(initAndGetFirstScreen: () async => Screens.s100);
  });

  test(
    'S100 ui.push(S200), when busy',
    () async {
      await rubigoRouter.busyService.busyWrapper(
        () async {
          await rubigoRouter.ui.push(Screens.s200);
        },
      );
      expect(
        rubigoRouter.screens.value.toListOfScreenId(),
        [
          Screens.s100,
        ],
      );
    },
  );

  test(
    'S100 ui.push(S200), when not busy',
    () async {
      await rubigoRouter.ui.push(Screens.s200);
      expect(
        rubigoRouter.screens.value.toListOfScreenId(),
        [
          Screens.s100,
          Screens.s200,
        ],
      );
    },
  );

  test(
    'S100 ui.replaceStack(S100-S200-S300), busy',
    () async {
      await rubigoRouter.busyService.busyWrapper(
        () async {
          await rubigoRouter.ui.replaceStack([
            Screens.s100,
            Screens.s200,
            Screens.s300,
          ]);
        },
      );
      expect(
        rubigoRouter.screens.value.toListOfScreenId(),
        [
          Screens.s100,
        ],
      );
    },
  );

  test(
    'S100 ui.replaceStack(S100-S200-S300), when not busy',
    () async {
      await rubigoRouter.ui.replaceStack([
        Screens.s100,
        Screens.s200,
        Screens.s300,
      ]);
      expect(
        rubigoRouter.screens.value.toListOfScreenId(),
        [
          Screens.s100,
          Screens.s200,
          Screens.s300,
        ],
      );
    },
  );

  test(
    'S100-s200-s300 ui.pop(), when busy',
    () async {
      await rubigoRouter.ui.replaceStack([
        Screens.s100,
        Screens.s200,
        Screens.s300,
      ]);
      await rubigoRouter.busyService.busyWrapper(
        () async {
          await rubigoRouter.ui.pop();
        },
      );
      expect(
        rubigoRouter.screens.value.toListOfScreenId(),
        [
          Screens.s100,
          Screens.s200,
          Screens.s300,
        ],
      );
    },
  );

  test(
    'S100-s200-s300 ui.pop(), when not busy',
    () async {
      await rubigoRouter.ui.replaceStack([
        Screens.s100,
        Screens.s200,
        Screens.s300,
      ]);
      await rubigoRouter.ui.pop();
      expect(
        rubigoRouter.screens.value.toListOfScreenId(),
        [
          Screens.s100,
          Screens.s200,
        ],
      );
    },
  );

  test(
    'S100-s200-s300 ui.popTo(S100) when busy',
    () async {
      await rubigoRouter.ui.replaceStack([
        Screens.s100,
        Screens.s200,
        Screens.s300,
      ]);
      await rubigoRouter.busyService.busyWrapper(
        () async {
          await rubigoRouter.ui.popTo(Screens.s100);
        },
      );
      expect(
        rubigoRouter.screens.value.toListOfScreenId(),
        [
          Screens.s100,
          Screens.s200,
          Screens.s300,
        ],
      );
    },
  );

  test(
    'S100-s200-s300 ui.popTo(S100) when not busy',
    () async {
      await rubigoRouter.ui.replaceStack([
        Screens.s100,
        Screens.s200,
        Screens.s300,
      ]);
      await rubigoRouter.ui.popTo(Screens.s100);
      expect(
        rubigoRouter.screens.value.toListOfScreenId(),
        [
          Screens.s100,
        ],
      );
    },
  );

  test(
    'S100-s200-s300 ui.remove(S200) when busy',
    () async {
      await rubigoRouter.ui.replaceStack([
        Screens.s100,
        Screens.s200,
        Screens.s300,
      ]);
      await rubigoRouter.busyService.busyWrapper(
        () async {
          await rubigoRouter.ui.remove(Screens.s200);
        },
      );
      expect(
        rubigoRouter.screens.value.toListOfScreenId(),
        [
          Screens.s100,
          Screens.s200,
          Screens.s300,
        ],
      );
    },
  );

  test(
    'S100-s200-s300 ui.remove(S200) when not busy',
    () async {
      await rubigoRouter.ui.replaceStack([
        Screens.s100,
        Screens.s200,
        Screens.s300,
      ]);
      await rubigoRouter.ui.remove(Screens.s200);
      expect(
        rubigoRouter.screens.value.toListOfScreenId(),
        [
          Screens.s100,
          Screens.s300,
        ],
      );
    },
  );
}
