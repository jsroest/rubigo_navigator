import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_rubigo_navigator/navigator/rubigo_controllers.dart';
import 'package:flutter_rubigo_navigator/navigator/rubigo_navigator.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}
//https://github.com/slightfoot/flutter_nav_v2/blob/master/lib/navigator_example.dart
//https://github.com/flutter/flutter/issues/66349

class _AppState extends State<App> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    var navigator = context.read(rubigoNavigatorProvider);
    var controllers = context.read(rubigoControllerProvider);
    navigator.init(controllers);
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
