import 'package:flutter_test/flutter_test.dart';
import 'package:rubigo_router/rubigo_router.dart';

import 'helpers/rubigo_screen_creators.dart';
import 'helpers/screens/mocks/callbacks.dart';
import 'helpers/screens/mocks/mock_controller.dart';
import 'helpers/screens/s100/s100_controller.dart';
import 'helpers/screens/s200/s200_controller_may_pop_returns_false.dart';
import 'helpers/screens/s300/s300_controller.dart';
import 'helpers/screens/screens.dart';
import 'helpers/screens/splash_screen/splash_controller.dart';

extension GetExtension<SCREEN_ID extends Enum> on RubigoControllerHolder {
  MockController<SCREEN_ID>
      getController<T extends MockController<SCREEN_ID>>() =>
          get<T>() as MockController<SCREEN_ID>;
}

void main() {
  late RubigoControllerHolder holder;
  late RubigoRouter<Screens> rubigoRouter;

  setUp(
    () async {
      holder = RubigoControllerHolder();
      final availableScreens = [
        getSplashScreen(holder),
        getS100Screen(holder),
        getS200ScreenMayPopReturnsFalse(holder),
        getS300Screen(holder),
      ];
      rubigoRouter = RubigoRouter<Screens>(
        splashScreenId: Screens.splashScreen,
        availableScreens: availableScreens,
      );
      await rubigoRouter.init(
        initAndGetFirstScreen: () async => Screens.s100,
      );
    },
  );

  test(
    'Test events splashScreen s100',
    () async {
      final splashController = holder.getController<SplashController>();
      {
        final actualCallBackHistory = splashController.callBackHistory;
        final expectedCallBackHistory = <CallBack>[];
        expect(actualCallBackHistory, expectedCallBackHistory);
      }
      final s100Controller = holder.getController<S100Controller>();
      {
        final actualCallBackHistory = s100Controller.callBackHistory;
        final expectedCallBackHistory = [
          OnTopCallBack(
            const RubigoChangeInfo<Screens>(
              EventType.replaceStack,
              Screens.splashScreen,
              [Screens.s100],
            ),
          ),
          WillShowCallBack(
            const RubigoChangeInfo<Screens>(
              EventType.replaceStack,
              Screens.splashScreen,
              [Screens.s100],
            ),
          ),
          IsShownCallBack(
            const RubigoChangeInfo<Screens>(
              EventType.replaceStack,
              Screens.splashScreen,
              [Screens.s100],
            ),
          ),
        ];
        expect(actualCallBackHistory, expectedCallBackHistory);
        expect(
          actualCallBackHistory[0].hashCode,
          expectedCallBackHistory[0].hashCode,
        );
      }
      final s200Controller =
          holder.getController<S200ControllerMayPopReturnsFalse>();
      {
        final actualCallBackHistory = s200Controller.callBackHistory;
        final expectedCallBackHistory = <CallBack>[];
        expect(actualCallBackHistory, expectedCallBackHistory);
      }
      final s300Controller = holder.getController<S300Controller>();
      {
        final actualCallBackHistory = s300Controller.callBackHistory;
        final expectedCallBackHistory = <CallBack>[];
        expect(actualCallBackHistory, expectedCallBackHistory);
      }
    },
  );
}
