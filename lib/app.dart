import 'package:flutter/material.dart';
import 'package:flutter_rubigo_navigator/app_providers.dart';
import 'package:flutter_rubigo_navigator/navigator/rubigo_navigator.dart';
import 'package:provider/provider.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}
//https://github.com/slightfoot/flutter_nav_v2/blob/master/lib/navigator_example.dart
//https://github.com/flutter/flutter/issues/66349

class _AppState extends State<App> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      builder: (BuildContext context, _) {
        var rubigoNavigator = context.watch<RubigoNavigator>();
        return MaterialApp(
          navigatorKey: _navigatorKey,
          onGenerateRoute: (_) => null,
          title: 'Flutter Navigator Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          builder: (context, _) {
            return Navigator(
              key: _navigatorKey,
              pages: rubigoNavigator.pages,
              onPopPage: rubigoNavigator.onPopPage,
            );
          },
        );
      },
    );
  }
}
