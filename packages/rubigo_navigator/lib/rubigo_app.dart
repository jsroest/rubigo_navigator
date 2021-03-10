import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rubigo_navigator/rubigo.dart';

class RubigoApp<PAGE_ENUM> extends StatefulWidget {
  const RubigoApp({
    Key key,
    @required this.pages,
    @required this.navigatorProvider,
    this.materialApp,
  }) : super(key: key);

  @override
  _RubigoAppState createState() => _RubigoAppState<PAGE_ENUM>();

  final Map<PAGE_ENUM, RubigoController<PAGE_ENUM>> Function(
      BuildContext context) pages;
  final ChangeNotifierProvider<RubigoNavigator<PAGE_ENUM>> navigatorProvider;
  final MaterialApp materialApp;
}

class _RubigoAppState<PAGE_ENUM> extends State<RubigoApp<PAGE_ENUM>> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    var navigator = context.read(widget.navigatorProvider);
    var pages = widget.pages(context);
    pages.forEach((key, value) => value.init(navigator));
    navigator.init(
      controllers: LinkedHashMap.of(pages),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) =>
      widget.materialApp ??
      MaterialApp(
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
