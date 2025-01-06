import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';

class RubigoMaterialApp<SCREEN_ID extends Enum> extends StatefulWidget {
  const RubigoMaterialApp({
    required this.routerDelegate,
    required this.initAndGetFirstScreen,
    super.key,
  });

  final RubigoRouterDelegate<SCREEN_ID> routerDelegate;
  final Future<SCREEN_ID> Function() initAndGetFirstScreen;

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
          listener: widget.routerDelegate.rubigoRouter.rubigoBusy.notifier,
          child: child!,
        );
      },
    );
  }
}
