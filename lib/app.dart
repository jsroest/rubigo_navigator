import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_rubigo_navigator/navigator/rubigo_navigator.dart';
import 'package:flutter_rubigo_navigator/pages/s010_login/s010_controller.dart';
import 'package:flutter_rubigo_navigator/pages/s020_main_menu/s020_controller.dart';
import 'package:flutter_rubigo_navigator/pages/s030_sub_page/s030_controller.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    var navigator = context.read(rubigoNavigatorProvider);
    navigator.init(
      controllers: [
        context.read(s010ControllerProvider),
        context.read(s020ControllerProvider),
        context.read(s030ControllerProvider(S030.V01)),
        context.read(s030ControllerProvider(S030.V02)),
        context.read(s030ControllerProvider(S030.V03)),
        context.read(s030ControllerProvider(S030.V04)),
        context.read(s030ControllerProvider(S030.V05)),
        context.read(s030ControllerProvider(S030.V06)),
        context.read(s030ControllerProvider(S030.V07)),
        context.read(s030ControllerProvider(S030.V08)),
        context.read(s030ControllerProvider(S030.V09)),
        context.read(s030ControllerProvider(S030.V10)),
      ],
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      onGenerateRoute: (_) => null,
      title: 'Flutter Navigator Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      builder: (context, _) {
        return Consumer(
          builder: (context, watch, child) {
            return Navigator(
              key: _navigatorKey,
              pages: watch(rubigoNavigatorProvider).pages,
              onPopPage: context.read(rubigoNavigatorProvider).onPopPage,
            );
          },
        );
      },
    );
  }
}
