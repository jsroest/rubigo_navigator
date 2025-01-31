import 'package:flutter_test/flutter_test.dart';
import 'package:rubigo_router/rubigo_router.dart';

import 'screens/mocks/callbacks.dart';
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
        () => holder.getOrCreate(SplashRubigoController.new),
      ),
      RubigoScreen(
        Screens.s100,
        S100Screen(),
        () => holder.getOrCreate(S100RubigoController.new),
      ),
      RubigoScreen(
        Screens.s200,
        S200Screen(),
        () => holder.getOrCreate(S200RubigoController.new),
      ),
      RubigoScreen(
        Screens.s300,
        S300Screen(),
        () => holder.getOrCreate(S300RubigoController.new),
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
      final s100Controller = holder.get<S100RubigoController>();
      s100Controller.callBackHistory.clear();
      final s200Controller = holder.get<S200RubigoController>();
      s200Controller.callBackHistory.clear();
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
      expect(
        s100Controller.callBackHistory,
        <CallBack>[],
      );
      expect(
        s200Controller.callBackHistory,
        <CallBack>[],
      );
    },
  );

  test(
    'S100 ui.push(S200), when not busy',
    () async {
      final s100Controller = holder.get<S100RubigoController>();
      s100Controller.callBackHistory.clear();
      final s200Controller = holder.get<S200RubigoController>();
      s200Controller.callBackHistory.clear();
      await rubigoRouter.ui.push(Screens.s200);
      expect(
        rubigoRouter.screens.value.toListOfScreenId(),
        [
          Screens.s100,
          Screens.s200,
        ],
      );
      expect(
        s100Controller.callBackHistory,
        <CallBack>[],
      );
      expect(
        s200Controller.callBackHistory,
        [
          OnTopCallBack(
            const RubigoChangeInfo(
              EventType.push,
              Screens.s100,
              [
                Screens.s100,
                Screens.s200,
              ],
            ),
          ),
          WillShowCallBack(
            const RubigoChangeInfo(
              EventType.push,
              Screens.s100,
              [
                Screens.s100,
                Screens.s200,
              ],
            ),
          ),
        ],
      );
    },
  );

  test(
    'S100 ui.replaceStack(S100-S200-S300), when busy',
    () async {
      final s100Controller = holder.get<S100RubigoController>();
      s100Controller.callBackHistory.clear();
      final s200Controller = holder.get<S200RubigoController>();
      s200Controller.callBackHistory.clear();
      final s300Controller = holder.get<S300RubigoController>();
      s300Controller.callBackHistory.clear();
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
      expect(
        s100Controller.callBackHistory,
        <CallBack>[],
      );
      expect(
        s200Controller.callBackHistory,
        <CallBack>[],
      );
      expect(
        s300Controller.callBackHistory,
        <CallBack>[],
      );
    },
  );

  test(
    'S100 ui.replaceStack(S100-S200-S300), when not busy',
    () async {
      final s100Controller = holder.get<S100RubigoController>();
      s100Controller.callBackHistory.clear();
      final s200Controller = holder.get<S200RubigoController>();
      s200Controller.callBackHistory.clear();
      final s300Controller = holder.get<S300RubigoController>();
      s300Controller.callBackHistory.clear();
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
      expect(
        s100Controller.callBackHistory,
        <CallBack>[],
      );
      expect(
        s200Controller.callBackHistory,
        <CallBack>[],
      );
      expect(
        s300Controller.callBackHistory,
        [
          OnTopCallBack(
            const RubigoChangeInfo(
              EventType.replaceStack,
              Screens.s100,
              [
                Screens.s100,
                Screens.s200,
                Screens.s300,
              ],
            ),
          ),
          WillShowCallBack(
            const RubigoChangeInfo(
              EventType.replaceStack,
              Screens.s100,
              [
                Screens.s100,
                Screens.s200,
                Screens.s300,
              ],
            ),
          ),
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
      final s100Controller = holder.get<S100RubigoController>()
        ..callBackHistory.clear();
      final s200Controller = holder.get<S200RubigoController>()
        ..callBackHistory.clear();
      final s300Controller = holder.get<S300RubigoController>()
        ..callBackHistory.clear();
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
      expect(
        s100Controller.callBackHistory,
        <CallBack>[],
      );
      expect(
        s200Controller.callBackHistory,
        <CallBack>[],
      );
      expect(
        s300Controller.callBackHistory,
        <CallBack>[],
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
      final s100Controller = holder.get<S100RubigoController>()
        ..callBackHistory.clear();
      final s200Controller = holder.get<S200RubigoController>()
        ..callBackHistory.clear();
      final s300Controller = holder.get<S300RubigoController>()
        ..callBackHistory.clear();
      await rubigoRouter.ui.pop();
      expect(
        rubigoRouter.screens.value.toListOfScreenId(),
        [
          Screens.s100,
          Screens.s200,
        ],
      );
      expect(
        s100Controller.callBackHistory,
        <CallBack>[],
      );
      expect(
        s200Controller.callBackHistory,
        [
          OnTopCallBack(
            const RubigoChangeInfo(
              EventType.pop,
              Screens.s300,
              [
                Screens.s100,
                Screens.s200,
              ],
            ),
          ),
          WillShowCallBack(
            const RubigoChangeInfo(
              EventType.pop,
              Screens.s300,
              [
                Screens.s100,
                Screens.s200,
              ],
            ),
          ),
        ],
      );
      expect(
        s300Controller.callBackHistory,
        <CallBack>[
          MayPopCallBack(mayPop: true),
          RemovedFromStackCallBack(),
        ],
      );
    },
  );

  test(
    'S100-s200-s300 ui.popTo(S100), when busy',
    () async {
      await rubigoRouter.ui.replaceStack([
        Screens.s100,
        Screens.s200,
        Screens.s300,
      ]);
      final s100Controller = holder.get<S100RubigoController>()
        ..callBackHistory.clear();
      final s200Controller = holder.get<S200RubigoController>()
        ..callBackHistory.clear();
      final s300Controller = holder.get<S300RubigoController>()
        ..callBackHistory.clear();
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
      expect(
        s100Controller.callBackHistory,
        <CallBack>[],
      );
      expect(
        s200Controller.callBackHistory,
        <CallBack>[],
      );
      expect(
        s300Controller.callBackHistory,
        <CallBack>[],
      );
    },
  );

  test(
    'S100-s200-s300 ui.popTo(S100), when not busy',
    () async {
      await rubigoRouter.ui.replaceStack([
        Screens.s100,
        Screens.s200,
        Screens.s300,
      ]);
      final s100Controller = holder.get<S100RubigoController>()
        ..callBackHistory.clear();
      final s200Controller = holder.get<S200RubigoController>()
        ..callBackHistory.clear();
      final s300Controller = holder.get<S300RubigoController>()
        ..callBackHistory.clear();
      await rubigoRouter.ui.popTo(Screens.s100);
      expect(
        rubigoRouter.screens.value.toListOfScreenId(),
        [
          Screens.s100,
        ],
      );
      expect(
        s100Controller.callBackHistory,
        [
          OnTopCallBack(
            const RubigoChangeInfo(
              EventType.popTo,
              Screens.s300,
              [
                Screens.s100,
              ],
            ),
          ),
          WillShowCallBack(
            const RubigoChangeInfo(
              EventType.popTo,
              Screens.s300,
              [
                Screens.s100,
              ],
            ),
          ),
        ],
      );
      expect(
        s200Controller.callBackHistory,
        <CallBack>[RemovedFromStackCallBack()],
      );
      expect(
        s300Controller.callBackHistory,
        <CallBack>[RemovedFromStackCallBack()],
      );
    },
  );

  test(
    'S100-s200-s300 ui.remove(S200), when busy',
    () async {
      await rubigoRouter.ui.replaceStack([
        Screens.s100,
        Screens.s200,
        Screens.s300,
      ]);
      final s100Controller = holder.get<S100RubigoController>()
        ..callBackHistory.clear();
      final s200Controller = holder.get<S200RubigoController>()
        ..callBackHistory.clear();
      final s300Controller = holder.get<S300RubigoController>()
        ..callBackHistory.clear();
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
      expect(
        s100Controller.callBackHistory,
        <CallBack>[],
      );
      expect(
        s200Controller.callBackHistory,
        <CallBack>[],
      );
      expect(
        s300Controller.callBackHistory,
        <CallBack>[],
      );
    },
  );

  test(
    'S100-s200-s300 ui.remove(S200), when not busy',
    () async {
      await rubigoRouter.ui.replaceStack([
        Screens.s100,
        Screens.s200,
        Screens.s300,
      ]);
      final s100Controller = holder.get<S100RubigoController>()
        ..callBackHistory.clear();
      final s200Controller = holder.get<S200RubigoController>()
        ..callBackHistory.clear();
      final s300Controller = holder.get<S300RubigoController>()
        ..callBackHistory.clear();
      await rubigoRouter.ui.remove(Screens.s200);
      expect(
        rubigoRouter.screens.value.toListOfScreenId(),
        [
          Screens.s100,
          Screens.s300,
        ],
      );
      expect(
        s100Controller.callBackHistory,
        <CallBack>[],
      );
      expect(
        s200Controller.callBackHistory,
        <CallBack>[RemovedFromStackCallBack()],
      );
      expect(
        s300Controller.callBackHistory,
        <CallBack>[],
      );
    },
  );
}
