import 'package:example/dependency_injection.dart';
import 'package:example/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';

class App extends StatefulWidget {
  const App({required this.rubigoBusyService, super.key});

  final RubigoBusyService rubigoBusyService;

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
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      backButtonDispatcher: RootBackButtonDispatcher(),
      routerDelegate: _routerDelegate,
      builder: (context, child) => RubigoBusy(
        listener: widget.rubigoBusyService.notifier,
        child: child!,
      ),
    );
  }
}
