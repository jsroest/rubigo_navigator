import 'package:flutter_test/flutter_test.dart';
import 'package:rubigo_router/rubigo_router.dart';

import 'helpers/rubigo_screen_creators.dart';
import 'helpers/screens/mocks/callbacks.dart';
import 'helpers/screens/mocks/mock_controller.dart';
import 'helpers/screens/s100/s100_controller.dart';
import 'helpers/screens/s200/s200_controller_may_pop_returns_false.dart';
import 'helpers/screens/s300/s300_controller.dart';
import 'helpers/screens/s400/s400_controller.dart';
import 'helpers/screens/s700/s700_controller.dart';
import 'helpers/screens/screens.dart';
import 'helpers/screens/splash_screen/splash_controller.dart';

extension GetExtension<SCREEN_ID extends Enum> on RubigoControllerHolder {
  MockController<SCREEN_ID>
      getController<T extends MockController<SCREEN_ID>>() =>
          get<T>() as MockController<SCREEN_ID>;
}

void main() {
  final holder = RubigoControllerHolder();
  final splashScreen = getSplashScreen(holder);
  final s100Screen = getS100Screen(holder);
  final s200Screen = getS200ScreenMayPopReturnsFalse(holder);
  final s300Screen = getS300Screen(holder);
  final s400Screen = getS400Screen(holder);
  final s500Screen = getS500Screen(holder);
  final s600Screen = getS600Screen(holder);
  final s700Screen = getS700Screen(holder);
  final availableScreens = [
    splashScreen,
    s100Screen,
    s200Screen,
    s300Screen,
    s400Screen,
    s500Screen,
    s600Screen,
    s700Screen,
  ];
  final rubigoRouter = RubigoRouter<Screens>(
    splashScreenId: Screens.splashScreen,
    availableScreens: availableScreens,
  );

  void clearCallBackHistory() {
    for (final screen in availableScreens) {
      final controller = screen.getController();
      if (controller is MockController) {
        controller.callBackHistory.clear();
      }
    }
  }

  List<Screens> screenStack() => rubigoRouter.screens.value.toListOfScreenId();

  void checkCallBackHistory<T>(
    List<CallBack> expectedCallBackHistory,
  ) {
    for (final screen in availableScreens) {
      final controller = screen.getController();
      late final List<CallBack> callBackHistory;
      if (controller is MockController) {
        callBackHistory = controller.callBackHistory;
      } else {
        callBackHistory = <CallBack>[];
      }
      if (controller is T) {
        expect(callBackHistory, expectedCallBackHistory);
      } else {
        expect(callBackHistory.length, 0);
      }
    }
  }

  test(
    'Test controller events',
    () async {
      //region Startup: SplashScreen
      expect(
        screenStack(),
        [Screens.splashScreen],
      );
      var expectedCallBackHistory = <CallBack>[];
      checkCallBackHistory<SplashController>(expectedCallBackHistory);
      expect(rubigoRouter.busyService.isBusy, false);
      //endregion

      //region RubigoRouter.init: S100
      clearCallBackHistory();
      await rubigoRouter.init(
        initAndGetFirstScreen: () async => Screens.s100,
      );
      expect(
        screenStack(),
        [Screens.s100],
      );

      expectedCallBackHistory = <CallBack>[
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
      checkCallBackHistory<S100Controller>(expectedCallBackHistory);
      expect(rubigoRouter.busyService.isBusy, false);
      //endregion

      //region Push(S200): S100=>S200
      clearCallBackHistory();
      await rubigoRouter.push(Screens.s200);
      expect(
        screenStack(),
        [
          Screens.s100,
          Screens.s200,
        ],
      );
      expectedCallBackHistory = [
        OnTopCallBack(
          const RubigoChangeInfo<Screens>(
            EventType.push,
            Screens.s100,
            [
              Screens.s100,
              Screens.s200,
            ],
          ),
        ),
        WillShowCallBack(
          const RubigoChangeInfo<Screens>(
            EventType.push,
            Screens.s100,
            [
              Screens.s100,
              Screens.s200,
            ],
          ),
        ),
        IsShownCallBack(
          const RubigoChangeInfo<Screens>(
            EventType.push,
            Screens.s100,
            [
              Screens.s100,
              Screens.s200,
            ],
          ),
        ),
      ];
      checkCallBackHistory<S200ControllerMayPopReturnsFalse>(
        expectedCallBackHistory,
      );
      expect(rubigoRouter.busyService.isBusy, false);
      //endregion

      //region onDidRemovePage(S200): S100=>S200
      clearCallBackHistory();
      final page = availableScreens.find(Screens.s200).toMaterialPage();
      await rubigoRouter.onDidRemovePage(page);
      expect(
        screenStack(),
        [
          Screens.s100,
          Screens.s200,
        ],
      );
      expectedCallBackHistory = [MayPopCallBack(mayPop: false)];
      checkCallBackHistory<S200ControllerMayPopReturnsFalse>(
        expectedCallBackHistory,
      );
      expect(rubigoRouter.busyService.isBusy, false);
      //endregion

      //region Pop(S200): S100
      clearCallBackHistory();
      await rubigoRouter.pop();
      expect(
        screenStack(),
        [
          Screens.s100,
        ],
      );
      expectedCallBackHistory = [
        OnTopCallBack(
          const RubigoChangeInfo<Screens>(
            EventType.pop,
            Screens.s200,
            [Screens.s100],
          ),
        ),
        WillShowCallBack(
          const RubigoChangeInfo<Screens>(
            EventType.pop,
            Screens.s200,
            [Screens.s100],
          ),
        ),
        IsShownCallBack(
          const RubigoChangeInfo<Screens>(
            EventType.pop,
            Screens.s200,
            [Screens.s100],
          ),
        ),
      ];
      checkCallBackHistory<S100Controller>(expectedCallBackHistory);
      expect(rubigoRouter.busyService.isBusy, false);
      //endregion

      //region Push(S200): S100=>S200
      clearCallBackHistory();
      await rubigoRouter.push(Screens.s200);
      expect(
        screenStack(),
        [
          Screens.s100,
          Screens.s200,
        ],
      );
      expectedCallBackHistory = [
        OnTopCallBack(
          const RubigoChangeInfo<Screens>(
            EventType.push,
            Screens.s100,
            [Screens.s100, Screens.s200],
          ),
        ),
        WillShowCallBack(
          const RubigoChangeInfo<Screens>(
            EventType.push,
            Screens.s100,
            [Screens.s100, Screens.s200],
          ),
        ),
        IsShownCallBack(
          const RubigoChangeInfo<Screens>(
            EventType.push,
            Screens.s100,
            [Screens.s100, Screens.s200],
          ),
        ),
      ];
      checkCallBackHistory<S200ControllerMayPopReturnsFalse>(
        expectedCallBackHistory,
      );
      expect(rubigoRouter.busyService.isBusy, false);
      //endregion

      //region Push(S300): S100=>S200=>S300
      clearCallBackHistory();
      await rubigoRouter.push(Screens.s300);
      expect(
        screenStack(),
        [
          Screens.s100,
          Screens.s200,
          Screens.s300,
        ],
      );
      expectedCallBackHistory = [
        OnTopCallBack(
          const RubigoChangeInfo<Screens>(
            EventType.push,
            Screens.s200,
            [Screens.s100, Screens.s200, Screens.s300],
          ),
        ),
        WillShowCallBack(
          const RubigoChangeInfo<Screens>(
            EventType.push,
            Screens.s200,
            [Screens.s100, Screens.s200, Screens.s300],
          ),
        ),
        IsShownCallBack(
          const RubigoChangeInfo<Screens>(
            EventType.push,
            Screens.s200,
            [Screens.s100, Screens.s200, Screens.s300],
          ),
        ),
      ];
      checkCallBackHistory<S300Controller>(expectedCallBackHistory);
      expect(rubigoRouter.busyService.isBusy, false);
      //endregion

      //region Push(S400): S100=>S200=>S300=>S400
      clearCallBackHistory();
      await rubigoRouter.push(Screens.s400);
      expect(
        screenStack(),
        [
          Screens.s100,
          Screens.s200,
          Screens.s300,
          Screens.s400,
        ],
      );
      expectedCallBackHistory = [
        OnTopCallBack(
          const RubigoChangeInfo<Screens>(
            EventType.push,
            Screens.s300,
            [Screens.s100, Screens.s200, Screens.s300, Screens.s400],
          ),
        ),
        WillShowCallBack(
          const RubigoChangeInfo<Screens>(
            EventType.push,
            Screens.s300,
            [Screens.s100, Screens.s200, Screens.s300, Screens.s400],
          ),
        ),
        IsShownCallBack(
          const RubigoChangeInfo<Screens>(
            EventType.push,
            Screens.s300,
            [Screens.s100, Screens.s200, Screens.s300, Screens.s400],
          ),
        ),
      ];
      checkCallBackHistory<S400Controller>(expectedCallBackHistory);
      expect(rubigoRouter.busyService.isBusy, false);
      //endregion

      //region PopTo(S200): S100=>S200
      clearCallBackHistory();
      await rubigoRouter.popTo(Screens.s200);
      expect(
        screenStack(),
        [
          Screens.s100,
          Screens.s200,
        ],
      );
      expectedCallBackHistory = [
        OnTopCallBack(
          const RubigoChangeInfo<Screens>(
            EventType.popTo,
            Screens.s400,
            [Screens.s100, Screens.s200],
          ),
        ),
        WillShowCallBack(
          const RubigoChangeInfo<Screens>(
            EventType.popTo,
            Screens.s400,
            [Screens.s100, Screens.s200],
          ),
        ),
        IsShownCallBack(
          const RubigoChangeInfo<Screens>(
            EventType.popTo,
            Screens.s400,
            [Screens.s100, Screens.s200],
          ),
        ),
      ];
      checkCallBackHistory<S200ControllerMayPopReturnsFalse>(
        expectedCallBackHistory,
      );
      expect(rubigoRouter.busyService.isBusy, false);
      //endregion

      //region ReplaceStack([S300, S400]): S300=> S400
      clearCallBackHistory();
      await rubigoRouter.replaceStack([Screens.s300, Screens.s400]);
      expect(
        screenStack(),
        [
          Screens.s300,
          Screens.s400,
        ],
      );
      expectedCallBackHistory = <CallBack>[
        OnTopCallBack(
          const RubigoChangeInfo<Screens>(
            EventType.replaceStack,
            Screens.s200,
            [Screens.s300, Screens.s400],
          ),
        ),
        WillShowCallBack(
          const RubigoChangeInfo<Screens>(
            EventType.replaceStack,
            Screens.s200,
            [Screens.s300, Screens.s400],
          ),
        ),
        IsShownCallBack(
          const RubigoChangeInfo<Screens>(
            EventType.replaceStack,
            Screens.s200,
            [Screens.s300, Screens.s400],
          ),
        ),
      ];
      checkCallBackHistory<S400Controller>(
        expectedCallBackHistory,
      );
      expect(rubigoRouter.busyService.isBusy, false);
      //endregion

      //region Pop() when busy: S300=> S400
      clearCallBackHistory();
      await rubigoRouter.busyService.busyWrapper(() async {
        await rubigoRouter.pop(ignoreWhenBusy: true);
        expect(
          screenStack(),
          [
            Screens.s300,
            Screens.s400,
          ],
        );
        expectedCallBackHistory = <CallBack>[];
        checkCallBackHistory<S400Controller>(expectedCallBackHistory);
      });
      expect(rubigoRouter.busyService.isBusy, false);
      //endregion

      //region Push(S700): S300=>S400=>S700
      clearCallBackHistory();
      await rubigoRouter.push(Screens.s700);
      expect(
        screenStack(),
        [
          Screens.s300,
          Screens.s400,
          Screens.s700,
        ],
      );
      expectedCallBackHistory = [];
      checkCallBackHistory<S700Controller>(
        expectedCallBackHistory,
      );
      expect(rubigoRouter.busyService.isBusy, false);
      //endregion

      //region popTo() => Exception
      clearCallBackHistory();
      expect(screenStack().containsScreenBelow(Screens.s500), false);
      await expectLater(
        () async => rubigoRouter.popTo(Screens.s500),
        throwsA(
          predicate(
            (e) =>
                e is UnsupportedError &&
                e.message ==
                    'Developer: With popTo, you tried to navigate to '
                        '${Screens.s500.name}, which was not on the stack.',
          ),
        ),
      );
      expect(rubigoRouter.busyService.isBusy, false);
      //endregion

      //region onDidRemovePage(S700): S300=> S400
      clearCallBackHistory();
      final page2 = availableScreens.find(Screens.s700).toMaterialPage();
      await rubigoRouter.onDidRemovePage(page2);
      expect(
        screenStack(),
        [
          Screens.s300,
          Screens.s400,
        ],
      );
      expectedCallBackHistory = [
        OnTopCallBack(
          const RubigoChangeInfo<Screens>(
            EventType.pop,
            Screens.s700,
            [
              Screens.s300,
              Screens.s400,
            ],
          ),
        ),
        WillShowCallBack(
          const RubigoChangeInfo<Screens>(
            EventType.pop,
            Screens.s700,
            [
              Screens.s300,
              Screens.s400,
            ],
          ),
        ),
        IsShownCallBack(
          const RubigoChangeInfo<Screens>(
            EventType.pop,
            Screens.s700,
            [
              Screens.s300,
              Screens.s400,
            ],
          ),
        ),
      ];
      checkCallBackHistory<S400Controller>(
        expectedCallBackHistory,
      );
      expect(rubigoRouter.busyService.isBusy, false);
      //endregion

      //region remove(S300)
      clearCallBackHistory();
      rubigoRouter.remove(Screens.s300);
      expect(
        screenStack(),
        [
          Screens.s400,
        ],
      );
      expectedCallBackHistory = <CallBack>[];
      checkCallBackHistory<S400Controller>(expectedCallBackHistory);
      expect(rubigoRouter.busyService.isBusy, false);
      //endregion

      //region remove(S300) => Exception
      clearCallBackHistory();
      expect(
        () => rubigoRouter.remove(Screens.s300),
        throwsA(
          predicate(
            (e) =>
                e is UnsupportedError &&
                e.message ==
                    'Developer: You can only remove screens that exist on the '
                        'stack (s300 not found).',
          ),
        ),
      );
      expect(rubigoRouter.busyService.isBusy, false);
      //endregion

      //region pop() => Exception
      clearCallBackHistory();
      expect(screenStack().hasScreenBelow(), false);
      await expectLater(
        () async => rubigoRouter.pop(),
        throwsA(
          predicate(
            (e) =>
                e is UnsupportedError &&
                e.message ==
                    'Developer: Pop was called on the last screen. The screen '
                        'stack may not be empty.',
          ),
        ),
      );
      expect(rubigoRouter.busyService.isBusy, false);
      //endregion

      //region Push(S600) => Exception
      clearCallBackHistory();
      await expectLater(
        () async => rubigoRouter.push(Screens.s600),
        throwsA(
          predicate(
            (e) =>
                e is UnsupportedError &&
                e.message ==
                    'Developer: you may not Push or Pop in the willShow '
                        'method.',
          ),
        ),
      );
      expect(rubigoRouter.busyService.isBusy, false);
      //endregion
    },
  );
}
