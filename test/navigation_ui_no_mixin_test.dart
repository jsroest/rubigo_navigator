import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rubigo_router/rubigo_router.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late RubigoHolder holder;
  late List<RubigoScreen<_Screens>> availableScreens;
  late RubigoRouter<_Screens> rubigoRouter;
  final logNavigation = <String>[];

  setUp(() async {
    logNavigation.clear();
    holder = RubigoHolder();
    availableScreens = [
      RubigoScreen(
        _Screens.splashScreen,
        const _SplashScreen(),
        () => holder.getOrCreate(_SplashController.new),
      ),
      RubigoScreen(
        _Screens.s100,
        const _S100Screen(),
        () => holder.getOrCreate(_S100Controller.new),
      ),
      RubigoScreen(
        _Screens.s200,
        const _S200Screen(),
        () => holder.getOrCreate(_S200Controller.new),
      ),
      RubigoScreen(
        _Screens.s300,
        const _S300Screen(),
        () => holder.getOrCreate(_S300Controller.new),
      ),
    ];
    rubigoRouter = RubigoRouter(
      availableScreens: availableScreens,
      splashScreenId: _Screens.splashScreen,
      logNavigation: (message) async => logNavigation.add(message),
    );
    await rubigoRouter.init(initAndGetFirstScreen: () async => _Screens.s100);
  });

  test(
    'S100 ui.push(S200), when busy',
    () async {
      await rubigoRouter.busyService.busyWrapper(
        () async {
          await rubigoRouter.ui.push(_Screens.s200);
        },
      );
      expect(
        rubigoRouter.screens.value.toListOfScreenId(),
        [
          _Screens.s100,
        ],
      );
      expect(
        logNavigation,
        [
          'RubigoRouter.init() called.',
          'RubigoRouter.init() ended. First screen will be s100.',
          'replaceStack(s100) called.',
          'Screens: s100.',
          'Push(s200) was called by the user, but the app is busy.',
        ],
      );
    },
  );

  test(
    'S100 ui.push(S200), when not busy',
    () async {
      await rubigoRouter.ui.push(_Screens.s200);
      expect(
        rubigoRouter.screens.value.toListOfScreenId(),
        [
          _Screens.s100,
          _Screens.s200,
        ],
      );
      expect(
        logNavigation,
        [
          'RubigoRouter.init() called.',
          'RubigoRouter.init() ended. First screen will be s100.',
          'replaceStack(s100) called.',
          'Screens: s100.',
          'push(s200) called.',
          'Screens: s100→s200.',
        ],
      );
    },
  );

  test(
    'S100 ui.replaceStack(S100-S200-S300), busy',
    () async {
      await rubigoRouter.busyService.busyWrapper(
        () async {
          await rubigoRouter.ui.replaceStack([
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
        ],
      );
      expect(
        logNavigation,
        [
          'RubigoRouter.init() called.',
          'RubigoRouter.init() ended. First screen will be s100.',
          'replaceStack(s100) called.',
          'Screens: s100.',
          //ignore: lines_longer_than_80_chars
          'replaceStack(S100→S200→S300) was called by the user, but the app is busy.',
        ],
      );
    },
  );

  test(
    'S100 ui.replaceStack(S100-S200-S300), when not busy',
    () async {
      await rubigoRouter.ui.replaceStack([
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
        logNavigation,
        [
          'RubigoRouter.init() called.',
          'RubigoRouter.init() ended. First screen will be s100.',
          'replaceStack(s100) called.',
          'Screens: s100.',
          'replaceStack(s100→s200→s300) called.',
          'Screens: s100→s200→s300.',
        ],
      );
    },
  );

  test(
    'S100-s200-s300 ui.pop(), when busy',
    () async {
      await rubigoRouter.ui.replaceStack([
        _Screens.s100,
        _Screens.s200,
        _Screens.s300,
      ]);
      await rubigoRouter.busyService.busyWrapper(
        () async {
          await rubigoRouter.ui.pop();
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
        logNavigation,
        [
          'RubigoRouter.init() called.',
          'RubigoRouter.init() ended. First screen will be s100.',
          'replaceStack(s100) called.',
          'Screens: s100.',
          'replaceStack(s100→s200→s300) called.',
          'Screens: s100→s200→s300.',
          'Pop was called by the user, but the app is busy.',
        ],
      );
    },
  );

  test(
    'S100-s200-s300 ui.pop(), when not busy',
    () async {
      await rubigoRouter.ui.replaceStack([
        _Screens.s100,
        _Screens.s200,
        _Screens.s300,
      ]);
      await rubigoRouter.ui.pop();
      expect(
        rubigoRouter.screens.value.toListOfScreenId(),
        [
          _Screens.s100,
          _Screens.s200,
        ],
      );
      expect(
        logNavigation,
        [
          'RubigoRouter.init() called.',
          'RubigoRouter.init() ended. First screen will be s100.',
          'replaceStack(s100) called.',
          'Screens: s100.',
          'replaceStack(s100→s200→s300) called.',
          'Screens: s100→s200→s300.',
          'The controller is not a RubigoControllerMixin, mayPop is always "true"',
          'pop() called.',
          'Screens: s100→s200.'
        ],
      );
    },
  );

  test(
    'S100-s200-s300 ui.popTo(S100) when busy',
    () async {
      await rubigoRouter.ui.replaceStack([
        _Screens.s100,
        _Screens.s200,
        _Screens.s300,
      ]);
      await rubigoRouter.busyService.busyWrapper(
        () async {
          await rubigoRouter.ui.popTo(_Screens.s100);
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
        logNavigation,
        [
          'RubigoRouter.init() called.',
          'RubigoRouter.init() ended. First screen will be s100.',
          'replaceStack(s100) called.',
          'Screens: s100.',
          'replaceStack(s100→s200→s300) called.',
          'Screens: s100→s200→s300.',
          'PopTo(s100) was called by the user, but the app is busy.',
        ],
      );
    },
  );

  test(
    'S100-s200-s300 ui.popTo(S100) when not busy',
    () async {
      await rubigoRouter.ui.replaceStack([
        _Screens.s100,
        _Screens.s200,
        _Screens.s300,
      ]);
      await rubigoRouter.ui.popTo(_Screens.s100);
      expect(
        rubigoRouter.screens.value.toListOfScreenId(),
        [
          _Screens.s100,
        ],
      );
      expect(
        logNavigation,
        [
          'RubigoRouter.init() called.',
          'RubigoRouter.init() ended. First screen will be s100.',
          'replaceStack(s100) called.',
          'Screens: s100.',
          'replaceStack(s100→s200→s300) called.',
          'Screens: s100→s200→s300.',
          'popTo(s100) called.',
          'Screens: s100.',
        ],
      );
    },
  );

  test(
    'S100-s200-s300 ui.remove(S200) when busy',
    () async {
      await rubigoRouter.ui.replaceStack([
        _Screens.s100,
        _Screens.s200,
        _Screens.s300,
      ]);
      await rubigoRouter.busyService.busyWrapper(
        () async {
          await rubigoRouter.ui.remove(_Screens.s200);
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
        logNavigation,
        [
          'RubigoRouter.init() called.',
          'RubigoRouter.init() ended. First screen will be s100.',
          'replaceStack(s100) called.',
          'Screens: s100.',
          'replaceStack(s100→s200→s300) called.',
          'Screens: s100→s200→s300.',
          'remove(s200) was called by the user, but the app is busy.',
        ],
      );
    },
  );

  test(
    'S100-s200-s300 ui.remove(S200) when not busy',
    () async {
      await rubigoRouter.ui.replaceStack([
        _Screens.s100,
        _Screens.s200,
        _Screens.s300,
      ]);
      await rubigoRouter.ui.remove(_Screens.s200);
      expect(
        rubigoRouter.screens.value.toListOfScreenId(),
        [
          _Screens.s100,
          _Screens.s300,
        ],
      );
      expect(
        logNavigation,
        [
          'RubigoRouter.init() called.',
          'RubigoRouter.init() ended. First screen will be s100.',
          'replaceStack(s100) called.',
          'Screens: s100.',
          'replaceStack(s100→s200→s300) called.',
          'Screens: s100→s200→s300.',
          'remove(s200) called.',
          'Screens: s100→s300.',
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

class _SplashController {}
//endregion

//region S100Screen
class _S100Screen extends StatelessWidget {
  //ignore: unused_element
  const _S100Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Placeholder(),
    );
  }
}

class _S100Controller {}
//endregion

//region S200Screen
class _S200Screen extends StatelessWidget {
  //ignore: unused_element
  const _S200Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Placeholder(),
    );
  }
}

class _S200Controller {}
//endregion

//region S300Screen
class _S300Screen extends StatelessWidget {
  //ignore: unused_element
  const _S300Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Placeholder(),
    );
  }
}

class _S300Controller {}
//endregion
