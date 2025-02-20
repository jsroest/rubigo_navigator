import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rubigo_router/rubigo_router.dart';

import 'mock_controller/mock_controller.dart';

void main() {
  final holder = RubigoHolder();
  final key = GlobalKey<NavigatorState>();

  test(
    'Navigator key passed',
    () {
      final rubigoNavigator = RubigoRouter<_Screens>(
        availableScreens: [
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
        ],
        navigatorKey: key,
        splashScreenId: _Screens.splashScreen,
      );
      expect(
        identical(rubigoNavigator.navigatorKey, key),
        true,
      );
    },
  );

  test(
    'Navigator key not passed',
    () {
      final rubigoNavigator = RubigoRouter<_Screens>(
        availableScreens: [
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
        ],
        splashScreenId: _Screens.splashScreen,
      );
      expect(
        identical(rubigoNavigator.navigatorKey, key),
        false,
      );
    },
  );
}

enum _Screens {
  splashScreen,
  s100,
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
