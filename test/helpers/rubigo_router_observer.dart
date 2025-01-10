import 'package:flutter/material.dart';
import 'package:mockito/annotations.dart';

@GenerateNiceMocks([MockSpec<NavigatorObserver>()])
class RubigoNavigatorObserver<SCREEN_ID extends Enum>
    extends NavigatorObserver {
  late SCREEN_ID currentScreenId;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    currentScreenId = routeToKey(route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    currentScreenId = routeToKey(previousRoute!);
  }

  SCREEN_ID routeToKey(Route<dynamic> route) {
    final settings = route.settings as MaterialPage;
    final key = settings.key! as ValueKey<SCREEN_ID>;
    return key.value;
  }
}
