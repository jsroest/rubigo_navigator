import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rubigo_router/rubigo_router.dart';

/// A sample how to wire-up Flutter's [MaterialApp.router] with
/// [RubigoRouterDelegate] and [RubigoBusyWidget].
/// This is a [StatefulWidget]. [RubigoRouter.init] is called in
/// [State.didChangeDependencies] to be sure that it is called **once** and only
/// when the BuildContext is **stable**.
class RubigoMaterialApp<SCREEN_ID extends Enum> extends StatefulWidget {
  /// Creates a RubigoMaterialApp
  const RubigoMaterialApp({
    required this.routerDelegate,
    required this.initAndGetFirstScreen,
    this.progressIndicator,
    super.key,
  });

  /// The router delegate to pass to [MaterialApp.router]
  final RubigoRouterDelegate<SCREEN_ID> routerDelegate;

  /// In this function the application can be initialized. During this phase
  /// a SplashScreen is shown. After initialisation this functions returns the
  /// first screen to navigate to, which is done with a
  /// [RubigoRouter.replaceStack].
  final Future<SCREEN_ID> Function() initAndGetFirstScreen;

  /// A custom progressIndicator widget.
  final Widget? progressIndicator;

  @override
  State<RubigoMaterialApp<SCREEN_ID>> createState() =>
      _RubigoMaterialAppState<SCREEN_ID>();
}

class _RubigoMaterialAppState<SCREEN_ID extends Enum>
    extends State<RubigoMaterialApp<SCREEN_ID>> {
  @override
  void didChangeDependencies() {
    unawaited(
      widget.routerDelegate.rubigoRouter.init(
        initAndGetFirstScreen: widget.initAndGetFirstScreen,
      ),
    );
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      backButtonDispatcher: RootBackButtonDispatcher(),
      routerDelegate: widget.routerDelegate,
      builder: (context, child) {
        return RubigoBusyWidget(
          progressIndicator: widget.progressIndicator,
          listener: widget.routerDelegate.rubigoRouter.busyService.notifier,
          child: child!,
        );
      },
    );
  }
}
