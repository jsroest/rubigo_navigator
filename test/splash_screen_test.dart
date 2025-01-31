import 'package:flutter_test/flutter_test.dart';
import 'package:rubigo_router/rubigo_router.dart';

import 'mock_controller/callbacks.dart';
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

  setUp(() {
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
  });

  test(
    'SplashScreen to S100',
    () async {
      await rubigoRouter.init(
        initAndGetFirstScreen: () async => Screens.s100,
      );
      expect(
        rubigoRouter.screens.value.toListOfScreenId(),
        [Screens.s100],
      );
      final splashController = holder.get<SplashRubigoController>();
      expect(
        splashController.callBackHistory,
        [RemovedFromStackCallBack()],
      );
      final s100Controller = holder.get<S100RubigoController>();
      expect(
        s100Controller.callBackHistory,
        [
          OnTopCallBack(
            const RubigoChangeInfo(
              EventType.replaceStack,
              Screens.splashScreen,
              [Screens.s100],
            ),
          ),
          WillShowCallBack(
            const RubigoChangeInfo(
              EventType.replaceStack,
              Screens.splashScreen,
              [Screens.s100],
            ),
          ),
        ],
      );
    },
  );
}
