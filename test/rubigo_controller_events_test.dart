import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rubigo_router/rubigo_router.dart';

import 'helpers/rubigo_screen_creators.dart';
import 'helpers/screens/mocks/callbacks.dart';
import 'helpers/screens/mocks/mock_controller.dart';
import 'helpers/screens/screens.dart';

extension GetExtension<SCREEN_ID extends Enum> on RubigoHolder {
  MockController<SCREEN_ID>
      getController<T extends MockController<SCREEN_ID>>() =>
          get<T>() as MockController<SCREEN_ID>;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final holder = RubigoHolder();
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

  void checkCallBackHistory({
    required Enum screenId,
    required List<CallBack> expectedCallBackHistory,
    required List<Enum> removedScreens,
  }) {
    for (final screen in availableScreens) {
      final controller = screen.getController();
      late final List<CallBack> callBackHistory;
      if (controller is MockController) {
        callBackHistory = controller.callBackHistory;
      } else {
        callBackHistory = <CallBack>[];
      }
      if (screen.screenId == screenId) {
        expect(callBackHistory, expectedCallBackHistory);
      } else if (removedScreens.contains(screen.screenId)) {
        expect(callBackHistory, <CallBack>[RemovedFromStackCallBack()]);
      } else {
        expect(callBackHistory.length, 0);
      }
    }
  }

  testWidgets(
    'Test controller events',
    (tester) async {
      //region Startup: SplashScreen
      expect(
        screenStack(),
        [Screens.splashScreen],
      );
      var expectedCallBackHistory = <CallBack>[];
      checkCallBackHistory(
        screenId: Screens.splashScreen,
        expectedCallBackHistory: expectedCallBackHistory,
        removedScreens: [],
      );
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
      ];
      checkCallBackHistory(
        screenId: Screens.s100,
        expectedCallBackHistory: expectedCallBackHistory,
        removedScreens: [Screens.splashScreen],
      );
      expect(rubigoRouter.busyService.isBusy, false);
      //endregion

      //region Push(S200): S100=>S200
      clearCallBackHistory();
      await rubigoRouter.prog.push(Screens.s200);
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
      ];
      checkCallBackHistory(
        screenId: Screens.s200,
        expectedCallBackHistory: expectedCallBackHistory,
        removedScreens: [],
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
      checkCallBackHistory(
        screenId: Screens.s200,
        expectedCallBackHistory: expectedCallBackHistory,
        removedScreens: [],
      );

      expect(rubigoRouter.busyService.isBusy, false);
      //endregion

      //region Pop(S200): S100
      clearCallBackHistory();
      await rubigoRouter.prog.pop();
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
      ];
      checkCallBackHistory(
        screenId: Screens.s100,
        expectedCallBackHistory: expectedCallBackHistory,
        removedScreens: [Screens.s200],
      );
      expect(rubigoRouter.busyService.isBusy, false);
      //endregion

      //region Push(S200): S100=>S200
      clearCallBackHistory();
      await rubigoRouter.prog.push(Screens.s200);
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
      ];
      checkCallBackHistory(
        screenId: Screens.s200,
        expectedCallBackHistory: expectedCallBackHistory,
        removedScreens: [],
      );
      expect(rubigoRouter.busyService.isBusy, false);
      //endregion

      //region Push(S300): S100=>S200=>S300
      clearCallBackHistory();
      await rubigoRouter.prog.push(Screens.s300);
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
      ];
      checkCallBackHistory(
        screenId: Screens.s300,
        expectedCallBackHistory: expectedCallBackHistory,
        removedScreens: [],
      );
      expect(rubigoRouter.busyService.isBusy, false);
      //endregion

      //region Push(S400): S100=>S200=>S300=>S400
      clearCallBackHistory();
      await rubigoRouter.prog.push(Screens.s400);
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
      ];
      checkCallBackHistory(
        screenId: Screens.s400,
        expectedCallBackHistory: expectedCallBackHistory,
        removedScreens: [],
      );
      expect(rubigoRouter.busyService.isBusy, false);
      //endregion

      //region PopTo(S200): S100=>S200
      clearCallBackHistory();
      await rubigoRouter.prog.popTo(Screens.s200);
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
      ];
      checkCallBackHistory(
        screenId: Screens.s200,
        expectedCallBackHistory: expectedCallBackHistory,
        removedScreens: [Screens.s300, Screens.s400],
      );
      expect(rubigoRouter.busyService.isBusy, false);
      //endregion

      //region ReplaceStack([S300, S400]): S300=> S400
      clearCallBackHistory();
      await rubigoRouter.prog.replaceStack([Screens.s300, Screens.s400]);
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
      ];
      checkCallBackHistory(
        screenId: Screens.s400,
        expectedCallBackHistory: expectedCallBackHistory,
        removedScreens: [Screens.s100, Screens.s200],
      );
      expect(rubigoRouter.busyService.isBusy, false);
      //endregion

      //region Pop() when busy: S300=> S400
      clearCallBackHistory();
      await rubigoRouter.busyService.busyWrapper(() async {
        await rubigoRouter.ui.pop();
        expect(
          screenStack(),
          [
            Screens.s300,
            Screens.s400,
          ],
        );
        expectedCallBackHistory = <CallBack>[];
        checkCallBackHistory(
          screenId: Screens.s400,
          expectedCallBackHistory: expectedCallBackHistory,
          removedScreens: [],
        );
      });
      expect(rubigoRouter.busyService.isBusy, false);
      //endregion

      //region Push(S700): S300=>S400=>S700
      clearCallBackHistory();
      await rubigoRouter.prog.push(Screens.s700);
      expect(
        screenStack(),
        [
          Screens.s300,
          Screens.s400,
          Screens.s700,
        ],
      );
      expectedCallBackHistory = [];
      checkCallBackHistory(
        screenId: Screens.s700,
        expectedCallBackHistory: expectedCallBackHistory,
        removedScreens: [],
      );
      expect(rubigoRouter.busyService.isBusy, false);
      //endregion

      //region popTo() => Exception
      clearCallBackHistory();
      expect(screenStack().containsScreenBelow(Screens.s500), false);
      await expectLater(
        () async => rubigoRouter.prog.popTo(Screens.s500),
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
      ];
      checkCallBackHistory(
        screenId: Screens.s400,
        expectedCallBackHistory: expectedCallBackHistory,
        removedScreens: [],
      );

      expect(rubigoRouter.busyService.isBusy, false);
      //endregion

      //region remove(S300)
      clearCallBackHistory();
      await rubigoRouter.prog.remove(Screens.s300);
      expect(
        screenStack(),
        [
          Screens.s400,
        ],
      );
      expectedCallBackHistory = <CallBack>[];
      checkCallBackHistory(
        screenId: Screens.s400,
        expectedCallBackHistory: expectedCallBackHistory,
        removedScreens: [Screens.s300],
      );
      expect(rubigoRouter.busyService.isBusy, false);
      //endregion

      //region remove(S300) => Exception
      clearCallBackHistory();
      expect(
        () => rubigoRouter.prog.remove(Screens.s300),
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
      var message = '';

      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (value) async {
          message = value.method;
          return null;
        },
      );
      await rubigoRouter.prog.pop();
      expect(message, 'SystemNavigator.pop');
      expect(rubigoRouter.busyService.isBusy, false);
      //endregion

      //region Push(S600) => Exception
      clearCallBackHistory();
      await expectLater(
        () async => rubigoRouter.prog.push(Screens.s600),
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
  SystemChannels.platform.setMethodCallHandler(null);
}
