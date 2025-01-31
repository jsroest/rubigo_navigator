import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rubigo_router/rubigo_router.dart';

import 'mock_controller/callbacks.dart';
import 'mock_controller/mock_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late RubigoHolder holder;
  late List<RubigoScreen<_Screens>> availableScreens;
  late RubigoRouter<_Screens> rubigoRouter;

  setUp(() async {
    holder = RubigoHolder();
    availableScreens = [
      RubigoScreen(
        _Screens.splashScreen,
        const _SplashScreen(),
        () => holder.getOrCreate(_SplashController.new),
      ),
      RubigoScreen(
        _Screens.s100,
        _S100Screen(),
        () => holder.getOrCreate(_S100Controller.new),
      ),
      RubigoScreen(
        _Screens.s200,
        _S200Screen(),
        () => holder.getOrCreate(_S200Controller.new),
      ),
      RubigoScreen(
        _Screens.s300,
        _S300Screen(),
        () => holder.getOrCreate(_S300Controller.new),
      ),
    ];
    rubigoRouter = RubigoRouter(
      availableScreens: availableScreens,
      splashScreenId: _Screens.splashScreen,
    );
    await rubigoRouter.init(initAndGetFirstScreen: () async => _Screens.s100);
  });

  test(
    'S100 prog.push(S200), when busy',
    () async {
      final s100Controller = holder.get<_S100Controller>();
      s100Controller.callBackHistory.clear();
      final s200Controller = holder.get<_S200Controller>();
      s200Controller.callBackHistory.clear();
      await rubigoRouter.busyService.busyWrapper(
        () async {
          await rubigoRouter.prog.push(_Screens.s200);
        },
      );

      expect(
        rubigoRouter.screens.value.toListOfScreenId(),
        [
          _Screens.s100,
          _Screens.s200,
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
              _Screens.s100,
              [
                _Screens.s100,
                _Screens.s200,
              ],
            ),
          ),
          WillShowCallBack(
            const RubigoChangeInfo(
              EventType.push,
              _Screens.s100,
              [
                _Screens.s100,
                _Screens.s200,
              ],
            ),
          ),
        ],
      );
    },
  );

  test(
    'S100 prog.push(S200), when not busy',
    () async {
      final s100Controller = holder.get<_S100Controller>();
      s100Controller.callBackHistory.clear();
      final s200Controller = holder.get<_S200Controller>();
      s200Controller.callBackHistory.clear();
      await rubigoRouter.prog.push(_Screens.s200);
      expect(
        rubigoRouter.screens.value.toListOfScreenId(),
        [
          _Screens.s100,
          _Screens.s200,
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
              _Screens.s100,
              [
                _Screens.s100,
                _Screens.s200,
              ],
            ),
          ),
          WillShowCallBack(
            const RubigoChangeInfo(
              EventType.push,
              _Screens.s100,
              [
                _Screens.s100,
                _Screens.s200,
              ],
            ),
          ),
        ],
      );
    },
  );

  test(
    'S100 prog.replaceStack(S100-S200-S300), busy',
    () async {
      final s100Controller = holder.get<_S100Controller>();
      s100Controller.callBackHistory.clear();
      final s200Controller = holder.get<_S200Controller>();
      s200Controller.callBackHistory.clear();
      final s300Controller = holder.get<_S300Controller>();
      s300Controller.callBackHistory.clear();
      await rubigoRouter.busyService.busyWrapper(
        () async {
          await rubigoRouter.prog.replaceStack([
            _Screens.s100,
            _Screens.s200,
            _Screens.s300,
          ]);
        },
      );
      expect(
        rubigoRouter.screens.value.toListOfScreenId(),
        [
          _Screens.s100,
          _Screens.s200,
          _Screens.s300,
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
              _Screens.s100,
              [
                _Screens.s100,
                _Screens.s200,
                _Screens.s300,
              ],
            ),
          ),
          WillShowCallBack(
            const RubigoChangeInfo(
              EventType.replaceStack,
              _Screens.s100,
              [
                _Screens.s100,
                _Screens.s200,
                _Screens.s300,
              ],
            ),
          ),
        ],
      );
    },
  );

  test(
    'S100 prog.replaceStack(S100-S200-S300), when not busy',
    () async {
      final s100Controller = holder.get<_S100Controller>();
      s100Controller.callBackHistory.clear();
      final s200Controller = holder.get<_S200Controller>();
      s200Controller.callBackHistory.clear();
      final s300Controller = holder.get<_S300Controller>();
      s300Controller.callBackHistory.clear();
      await rubigoRouter.prog.replaceStack([
        _Screens.s100,
        _Screens.s200,
        _Screens.s300,
      ]);
      expect(
        rubigoRouter.screens.value.toListOfScreenId(),
        [
          _Screens.s100,
          _Screens.s200,
          _Screens.s300,
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
              _Screens.s100,
              [
                _Screens.s100,
                _Screens.s200,
                _Screens.s300,
              ],
            ),
          ),
          WillShowCallBack(
            const RubigoChangeInfo(
              EventType.replaceStack,
              _Screens.s100,
              [
                _Screens.s100,
                _Screens.s200,
                _Screens.s300,
              ],
            ),
          ),
        ],
      );
    },
  );

  test(
    'S100-s200-s300 prog.pop(), when busy',
    () async {
      await rubigoRouter.prog.replaceStack([
        _Screens.s100,
        _Screens.s200,
        _Screens.s300,
      ]);
      final s100Controller = holder.get<_S100Controller>()
        ..callBackHistory.clear();
      final s200Controller = holder.get<_S200Controller>()
        ..callBackHistory.clear();
      final s300Controller = holder.get<_S300Controller>()
        ..callBackHistory.clear();
      await rubigoRouter.busyService.busyWrapper(
        () async {
          await rubigoRouter.prog.pop();
        },
      );

      expect(
        rubigoRouter.screens.value.toListOfScreenId(),
        [
          _Screens.s100,
          _Screens.s200,
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
              _Screens.s300,
              [
                _Screens.s100,
                _Screens.s200,
              ],
            ),
          ),
          WillShowCallBack(
            const RubigoChangeInfo(
              EventType.pop,
              _Screens.s300,
              [
                _Screens.s100,
                _Screens.s200,
              ],
            ),
          ),
        ],
      );
      expect(
        s300Controller.callBackHistory,
        <CallBack>[RemovedFromStackCallBack()],
      );
    },
  );

  test(
    'S100-s200-s300 prog.pop(), when not busy',
    () async {
      await rubigoRouter.prog.replaceStack([
        _Screens.s100,
        _Screens.s200,
        _Screens.s300,
      ]);
      final s100Controller = holder.get<_S100Controller>()
        ..callBackHistory.clear();
      final s200Controller = holder.get<_S200Controller>()
        ..callBackHistory.clear();
      final s300Controller = holder.get<_S300Controller>()
        ..callBackHistory.clear();
      await rubigoRouter.prog.pop();
      expect(
        rubigoRouter.screens.value.toListOfScreenId(),
        [
          _Screens.s100,
          _Screens.s200,
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
              _Screens.s300,
              [
                _Screens.s100,
                _Screens.s200,
              ],
            ),
          ),
          WillShowCallBack(
            const RubigoChangeInfo(
              EventType.pop,
              _Screens.s300,
              [
                _Screens.s100,
                _Screens.s200,
              ],
            ),
          ),
        ],
      );
      expect(
        s300Controller.callBackHistory,
        <CallBack>[RemovedFromStackCallBack()],
      );
    },
  );

  test(
    'S100-s200-s300 prog.popTo(S100) when busy',
    () async {
      await rubigoRouter.prog.replaceStack([
        _Screens.s100,
        _Screens.s200,
        _Screens.s300,
      ]);
      final s100Controller = holder.get<_S100Controller>()
        ..callBackHistory.clear();
      final s200Controller = holder.get<_S200Controller>()
        ..callBackHistory.clear();
      final s300Controller = holder.get<_S300Controller>()
        ..callBackHistory.clear();
      await rubigoRouter.busyService.busyWrapper(
        () async {
          await rubigoRouter.prog.popTo(_Screens.s100);
        },
      );
      expect(
        rubigoRouter.screens.value.toListOfScreenId(),
        [
          _Screens.s100,
        ],
      );
      expect(
        s100Controller.callBackHistory,
        [
          OnTopCallBack(
            const RubigoChangeInfo(
              EventType.popTo,
              _Screens.s300,
              [
                _Screens.s100,
              ],
            ),
          ),
          WillShowCallBack(
            const RubigoChangeInfo(
              EventType.popTo,
              _Screens.s300,
              [
                _Screens.s100,
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
    'S100-s200-s300 prog.popTo(S100) when not busy',
    () async {
      await rubigoRouter.prog.replaceStack([
        _Screens.s100,
        _Screens.s200,
        _Screens.s300,
      ]);
      final s100Controller = holder.get<_S100Controller>()
        ..callBackHistory.clear();
      final s200Controller = holder.get<_S200Controller>()
        ..callBackHistory.clear();
      final s300Controller = holder.get<_S300Controller>()
        ..callBackHistory.clear();
      await rubigoRouter.prog.popTo(_Screens.s100);
      expect(
        rubigoRouter.screens.value.toListOfScreenId(),
        [
          _Screens.s100,
        ],
      );
      expect(
        s100Controller.callBackHistory,
        [
          OnTopCallBack(
            const RubigoChangeInfo(
              EventType.popTo,
              _Screens.s300,
              [
                _Screens.s100,
              ],
            ),
          ),
          WillShowCallBack(
            const RubigoChangeInfo(
              EventType.popTo,
              _Screens.s300,
              [
                _Screens.s100,
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
    'S100-s200-s300 prog.remove(S200) when busy',
    () async {
      await rubigoRouter.prog.replaceStack([
        _Screens.s100,
        _Screens.s200,
        _Screens.s300,
      ]);
      final s100Controller = holder.get<_S100Controller>()
        ..callBackHistory.clear();
      final s200Controller = holder.get<_S200Controller>()
        ..callBackHistory.clear();
      final s300Controller = holder.get<_S300Controller>()
        ..callBackHistory.clear();
      await rubigoRouter.busyService.busyWrapper(
        () async {
          await rubigoRouter.prog.remove(_Screens.s200);
        },
      );
      expect(
        rubigoRouter.screens.value.toListOfScreenId(),
        [
          _Screens.s100,
          _Screens.s300,
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

  test(
    'S100-s200-s300 prog.remove(S200) when not busy',
    () async {
      await rubigoRouter.prog.replaceStack([
        _Screens.s100,
        _Screens.s200,
        _Screens.s300,
      ]);
      final s100Controller = holder.get<_S100Controller>()
        ..callBackHistory.clear();
      final s200Controller = holder.get<_S200Controller>()
        ..callBackHistory.clear();
      final s300Controller = holder.get<_S300Controller>()
        ..callBackHistory.clear();
      await rubigoRouter.prog.remove(_Screens.s200);
      expect(
        rubigoRouter.screens.value.toListOfScreenId(),
        [
          _Screens.s100,
          _Screens.s300,
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

enum _Screens {
  splashScreen,
  s100,
  s200,
  s300,
}

//region SplashScreen
class _SplashScreen extends StatelessWidget {
  //ignore: unused_element
  const _SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class _SplashController extends MockController<_Screens> {}
//endregion

//region S100Screen
class _S100Screen extends StatelessWidget
    with RubigoScreenMixin<_S100Controller> {
  //ignore: unused_element
  _S100Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: rubigoBackButton(context, controller.rubigoRouter),
      ),
      body: const Placeholder(),
    );
  }
}

class _S100Controller extends MockController<_Screens> {}
//endregion

//region S200Screen
class _S200Screen extends StatelessWidget
    with RubigoScreenMixin<_S200Controller> {
  //ignore: unused_element
  _S200Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: rubigoBackButton(context, controller.rubigoRouter),
      ),
      body: const Placeholder(),
    );
  }
}

class _S200Controller extends MockController<_Screens> {}
//endregion

//region S300Screen
class _S300Screen extends StatelessWidget
    with RubigoScreenMixin<_S200Controller> {
  //ignore: unused_element
  _S300Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: rubigoBackButton(context, controller.rubigoRouter),
      ),
      body: const Placeholder(),
    );
  }
}

class _S300Controller extends MockController<_Screens> {}
//endregion
