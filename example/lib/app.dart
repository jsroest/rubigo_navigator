import 'package:example/dependency_injection.dart';
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
    _routerDelegate = RubigoRouterDelegate(
      rubigoRouter: rubigoRouter,
      backCallback: BackCallback.onPopPage,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      backButtonDispatcher: RootBackButtonDispatcher(),
      routerDelegate: _routerDelegate,
      builder: (context, child) => ListenableBuilder(
        listenable: rubigoBusyService,
        builder: (BuildContext context, Widget? _) {
          return RubigoBusy(
            enabled: rubigoBusyService.enabled,
            isBusy: rubigoBusyService.isBusy,
            showProgressIndicator: rubigoBusyService.showProgressIndicator,
            child: child!,
          );
        },
      ),
    );
  }
}
