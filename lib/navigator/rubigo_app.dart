import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_rubigo_navigator/navigator/rubigo.dart';

class RubigoApp<PAGE_ENUM> extends StatefulWidget {
  const RubigoApp({
    Key key,
    @required this.pages,
    @required this.navigatorProvider,
  }) : super(key: key);

  @override
  _RubigoAppState createState() => _RubigoAppState<PAGE_ENUM>();

  final ChangeNotifierProvider<RubigoNavigator<PAGE_ENUM>> navigatorProvider;
  final Map<PAGE_ENUM, RubigoController<PAGE_ENUM>> Function(
      BuildContext context) pages;
}

class _RubigoAppState<PAGE_ENUM> extends State<RubigoApp<PAGE_ENUM>> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    var navigator = context.read(widget.navigatorProvider);
    navigator.init(
      controllers: LinkedHashMap.of(widget.pages(context)),
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
              pages: watch(widget.navigatorProvider).pages,
              onPopPage: context.read(widget.navigatorProvider).onPopPage,
            );
          },
        );
      },
    );
  }
}
