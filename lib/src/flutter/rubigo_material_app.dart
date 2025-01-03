import 'package:flutter/material.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';

class RubigoMaterialApp<SCREEN_ID extends Enum> extends StatelessWidget {
  const RubigoMaterialApp({
    required this.routerDelegate,
    super.key,
  });

  final RubigoRouterDelegate<SCREEN_ID> routerDelegate;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      backButtonDispatcher: RootBackButtonDispatcher(),
      routerDelegate: routerDelegate,
      builder: (context, child) {
        return RubigoBusyWidget(
          listener: routerDelegate.rubigoRouter.rubigoBusy.notifier,
          child: child!,
        );
      },
    );
  }
}
