import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rubigo_router/rubigo_router.dart';

import 'mock_controller/mock_controller.dart';

void main() {
  late RubigoRouter<_Screens> rubigoRouter;
  final logNavigation = <String>[];

  setUp(
    () {
      logNavigation.clear();
      final holder = RubigoHolder();
      final availableScreens = [
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
      ];
      rubigoRouter = RubigoRouter(
        availableScreens: availableScreens,
        splashScreenId: _Screens.splashScreen,
        logNavigation: (message) async => logNavigation.add(message),
      );
    },
  );
  testWidgets(
    'rubigoBackGesture',
    (tester) async {
      await tester.pumpWidget(
        RubigoMaterialApp(
          backButtonDispatcher: RubigoRootBackButtonDispatcher(rubigoRouter),
          routerDelegate: RubigoRouterDelegate(
            rubigoRouter: rubigoRouter,
          ),
          initAndGetFirstScreen: () async => _Screens.s100,
        ),
      );
      await tester.pumpAndSettle();
      await tester.runAsync(() async => rubigoRouter.ui.push(_Screens.s200));
      await tester.pumpAndSettle();
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.byType(_S100Screen), findsOne);
      expect(
        logNavigation,
        [
          'RubigoRouter.init() called.',
          'RubigoRouter.init() ended. First screen will be s100.',
          'replaceStack(s100) called.',
          'Screens: s100',
          'onDidRemovePage(splashScreen) called. Last page is s100, ignoring.',
          'push(s200) called.',
          'Screens: s100→s200',
          'Call mayPop().',
          'The controller returned "true"',
          'pop() called.',
          'Screens: s100',
          'onDidRemovePage(s200) called. Last page is s100, ignoring.'
        ],
      );
    },
  );
}

enum _Screens {
  splashScreen,
  s100,
  s200,
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
    return RubigoBackGesture(
      allowBackGesture: false,
      rubigoRouter: controller.rubigoRouter,
      child: Scaffold(
        appBar: AppBar(
            // This needs to be commented out to test the RubigoBackGesture
            // widget
            //leading: rubigoBackButton(context, controller.rubigoRouter),
            ),
        body: const Placeholder(),
      ),
    );
  }
}

class _S200Controller extends MockController<_Screens> {}
//endregion
