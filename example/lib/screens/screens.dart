import 'package:example/screens/set1/s100/s100_controller.dart';
import 'package:example/screens/set1/s100/s100_screen.dart';
import 'package:example/screens/set1/s110/s110_controller.dart';
import 'package:example/screens/set1/s110/s110_screen.dart';
import 'package:example/screens/set1/s120/s120_controller.dart';
import 'package:example/screens/set1/s120/s120_screen.dart';
import 'package:example/screens/set1/s130/s130_controller.dart';
import 'package:example/screens/set1/s130/s130_screen.dart';
import 'package:example/screens/set2/s200/s200_controller.dart';
import 'package:example/screens/set2/s200/s200_screen.dart';
import 'package:example/screens/set2/s210/s210_controller.dart';
import 'package:example/screens/set2/s210/s210_screen.dart';
import 'package:example/screens/set2/s220/s220_controller.dart';
import 'package:example/screens/set2/s220/s220_screen.dart';
import 'package:example/screens/set2/s230/s230_controller.dart';
import 'package:example/screens/set2/s230/s230_screen.dart';
import 'package:example/screens/splash_screen/splash_controller.dart';
import 'package:example/screens/splash_screen/splash_screen.dart';
import 'package:rubigo_router/rubigo_router.dart';

// All screens are defined here.
enum Screens {
  splashScreen,
  s100,
  s110,
  s120,
  s130,
  s200,
  s210,
  s220,
  s230,
}

// A simple service locator to hold controllers.
final holder = RubigoHolder();

// All available screens are defined here.
final ListOfRubigoScreens<Screens> availableScreens = [
  RubigoScreen(
    Screens.splashScreen,
    SplashScreen(),
    () => holder.get(SplashController.new),
  ),
  RubigoScreen(
    Screens.s100,
    S100Screen(),
    () => holder.get(S100Controller.new),
  ),
  RubigoScreen(
    Screens.s110,
    S110Screen(),
    () => holder.get(S110Controller.new),
  ),
  RubigoScreen(
    Screens.s120,
    S120Screen(),
    () => holder.get(S120Controller.new),
  ),
  RubigoScreen(
    Screens.s130,
    const S130Screen(),
    () => holder.get(S130Controller.new),
  ),
  RubigoScreen(
    Screens.s200,
    S200Screen(),
    () => holder.get(S200Controller.new),
  ),
  RubigoScreen(
    Screens.s210,
    S210Screen(),
    () => holder.get(S210Controller.new),
  ),
  RubigoScreen(
    Screens.s220,
    S220Screen(),
    () => holder.get(S220Controller.new),
  ),
  RubigoScreen(
    Screens.s230,
    const S230Screen(),
    () => holder.get(S230Controller.new),
  ),
];
