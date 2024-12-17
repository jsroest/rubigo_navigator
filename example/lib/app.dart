import 'package:example/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final RubigoRouterDelegate<Screens> _routerDelegate;

  @override
  void initState() {
    super.initState();
    final navigator = RubigoNavigator(
      initialScreenStack: [Screens.s100],
      availableScreens: availableScreens,
    );
    _routerDelegate = RubigoRouterDelegate(navigator);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      backButtonDispatcher: RootBackButtonDispatcher(),
      routerDelegate: _routerDelegate,
    );
  }
}
