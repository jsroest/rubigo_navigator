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
  //Use the _defaultLogNavigation here

  setUp(() {
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
  });

  test(
    'SplashScreen to S100',
    () async {
      await rubigoRouter.init(
        initAndGetFirstScreen: () async => _Screens.s100,
      );
      expect(
        rubigoRouter.screens.toListOfScreenId(),
        [_Screens.s100],
      );
      final splashController = holder.get<_SplashController>();
      expect(
        splashController.callBackHistory,
        [RemovedFromStackCallBack()],
      );
      final s100Controller = holder.get<_S100Controller>();
      expect(
        s100Controller.callBackHistory,
        [
          OnTopCallBack(
            const RubigoChangeInfo(
              EventType.replaceStack,
              _Screens.splashScreen,
              [_Screens.s100],
            ),
          ),
          WillShowCallBack(
            const RubigoChangeInfo(
              EventType.replaceStack,
              _Screens.splashScreen,
              [_Screens.s100],
            ),
          ),
        ],
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
    with RubigoScreenMixin<_S300Controller> {
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
