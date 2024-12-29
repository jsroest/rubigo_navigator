import 'package:example/screens/screens.dart';
import 'package:example/screens/set1/set1_state.dart';
import 'package:get_it/get_it.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';

final getIt = GetIt.instance;

RubigoRouter<Screens> get rubigoRouter => getIt.get<RubigoRouter<Screens>>();

void dependencyInjection() {
  getIt.registerSingleton(
    RubigoRouter(
      initialScreenStack: screenStackSet1,
      availableScreens: availableScreens,
    ),
  );
}
