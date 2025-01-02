import 'package:flutter/material.dart';
import 'package:rubigo_navigator/src/flutter/busy/rubigo_busy.dart';
import 'package:rubigo_navigator/src/flutter/busy/rubigo_busy_service.dart';
import 'package:rubigo_navigator/src/flutter/rubigo_router_delegate.dart';
import 'package:rubigo_navigator/src/rubigo_router.dart';

class RubigoMaterialApp<SCREEN_ID extends Enum> extends StatefulWidget {
  const RubigoMaterialApp({
    required this.rubigoRouter,
    this.rubigoBusyService,
    super.key,
  });

  final RubigoRouter<SCREEN_ID> rubigoRouter;
  final RubigoBusyService? rubigoBusyService;

  @override
  State<RubigoMaterialApp<SCREEN_ID>> createState() =>
      _RubigoMaterialAppState<SCREEN_ID>();
}

class _RubigoMaterialAppState<SCREEN_ID extends Enum>
    extends State<RubigoMaterialApp<SCREEN_ID>> {
  late final RubigoRouterDelegate<SCREEN_ID> _routerDelegate;

  @override
  void initState() {
    super.initState();
    _routerDelegate = RubigoRouterDelegate(
      rubigoRouter: widget.rubigoRouter,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      backButtonDispatcher: RootBackButtonDispatcher(),
      routerDelegate: _routerDelegate,
      builder: (context, child) {
        final rubigoBusyService = widget.rubigoBusyService;
        if (rubigoBusyService != null) {
          return RubigoBusy(
            listener: rubigoBusyService.notifier,
            child: child!,
          );
        }
        return child!;
      },
    );
  }
}
