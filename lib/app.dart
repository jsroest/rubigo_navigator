import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_rubigo_navigator/navigator/rubigo_navigator.dart';
import 'package:flutter_rubigo_navigator/pages/s010_login/s010_controller.dart';
import 'package:flutter_rubigo_navigator/pages/s010_login/s010_login.page.dart';

final rubigoNavigatorProvider = ChangeNotifierProvider<RubigoNavigator>(
  (ref) {
    return RubigoNavigator(
      controllers: [
        ref.watch(s010ControllerProvider),
      ],
      initialScreenController: S010LoginPage,
    );
  },
);

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
