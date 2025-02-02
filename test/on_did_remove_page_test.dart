import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rubigo_router/rubigo_router.dart';

import 'mock_controller/mock_controller.dart';

void main() {
  late RubigoHolder holder;
  late RubigoRouter<_Screens> rubigoRouter;
  final logNavigation = <String>[];

  setUp(
    () {
      logNavigation.clear();
      holder = RubigoHolder();
      final availableScreens = <RubigoScreen<_Screens>>[
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

  testWidgets('test a back gesture S100-S200 to S100', (tester) async {
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
    // Start perform a back gesture
    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    late final TransitionRoute<void> lastRoute;
    // https://stackoverflow.com/questions/50817086/how-to-check-which-the-current-route-is/50817399#50817399
    navigator.popUntil(
      (route) {
        lastRoute = route as TransitionRoute<void>;
        return true;
      },
    );
    lastRoute.handleStartBackGesture(progress: 75);
    await tester.pumpAndSettle();
    lastRoute.handleCommitBackGesture();
    // End perform a back gesture
    await tester.pumpAndSettle();
    expect(find.byType(_S100Screen), findsOne);
    expect(
      logNavigation,
      [
        'replaceStack(s100) called.',
        'Screens: S100',
        'onDidRemovePage(splashScreen) called. Last page is s100, ignoring.',
        'push(s200) called.',
        'Screens: S100→S200',
        'onDidRemovePage(s200) called.',
        'Call mayPop().',
        'The controller returned "true"',
        'pop() called.',
        'Screens: S100',
      ],
    );
  });

  testWidgets('onDidRemovePage - updateScreensIsCalled is false',
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
    holder.get<_S200Controller>().allowPop = false;
    await tester.runAsync(() async => rubigoRouter.ui.push(_Screens.s200));
    await tester.pumpAndSettle();
    // Start perform a back gesture
    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    late final TransitionRoute<void> lastRoute;
    // https://stackoverflow.com/questions/50817086/how-to-check-which-the-current-route-is/50817399#50817399
    navigator.popUntil(
      (route) {
        lastRoute = route as TransitionRoute<void>;
        return true;
      },
    );
    lastRoute.handleStartBackGesture(progress: 75);
    await tester.pumpAndSettle();
    lastRoute.handleCommitBackGesture();
    // End perform a back gesture
    await tester.pumpAndSettle();
    expect(find.byType(_S200Screen), findsOne);
    expect(
      logNavigation,
      [
        'replaceStack(s100) called.',
        'Screens: S100',
        'onDidRemovePage(splashScreen) called. Last page is s100, ignoring.',
        'push(s200) called.',
        'Screens: S100→S200',
        'onDidRemovePage(s200) called.',
        'Call mayPop().',
        'The controller returned "false"',
        'Screens: S100→S200',
      ],
    );
  });

  testWidgets('onDidRemovePage - execute workaround', (tester) async {
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
        'replaceStack(s100) called.',
        'Screens: S100',
        'onDidRemovePage(splashScreen) called. Last page is s100, ignoring.',
        'push(s200) called.',
        'Screens: S100→S200',
        'onDidRemovePage(s200) called.',
        '''
RubigoRouter warning.
"onDidRemovePage called" for s200, but the source was not a userGesture. 
The cause is most likely that Navigator.maybePop(context) was (indirectly) called.
This can happen when:
- A regular BackButton was used to pop this page. Solution: Use a rubigoBackButton in the AppBar.
- The MaterialApp.backButtonDispatcher was not a RubigoRootBackButtonDispatcher.
- The pop was not caught by a RubigoBackGesture widget.
''',
        'Call mayPop().',
        'The controller returned "true"',
        'pop() called.',
        'Screens: S100',
      ],
    );
  });
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
    return Scaffold(
      appBar: AppBar(
          // This needs to be commented out to test the special situations
          // in this unit test.
          // leading: rubigoBackButton(context, controller.rubigoRouter),
          ),
      body: const Placeholder(),
    );
  }
}

class _S200Controller extends MockController<_Screens> {
  bool allowPop = true;

  @override
  Future<bool> mayPop() async {
    await super.mayPop();
    return allowPop;
  }
}
//endregion
