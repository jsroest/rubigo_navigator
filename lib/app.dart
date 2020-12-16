import 'dart:collection';

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
      controllers: LinkedHashMap.of({
        'a': context.read(s010ControllerProvider),
        'b': context.read(s020ControllerProvider),
        'c': context.read(s030ControllerProvider),
      }),
    );
    super.initState();
  }

  // LinkedHashMap.fromEntries([
  // MapEntry('a', context.read(s010ControllerProvider)),
  // context.read(s020ControllerProvider),
  // context.read(s030ControllerProvider),
  // ]
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
