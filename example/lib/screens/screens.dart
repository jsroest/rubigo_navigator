import 'package:example/holder.dart';
import 'package:example/screens/set1/s100/s100_controller.dart';
import 'package:example/screens/set1/s100/s100_screen.dart';
import 'package:example/screens/set1/s200/s200_controller.dart';
import 'package:example/screens/set1/s200/s200_screen.dart';
import 'package:example/screens/set1/s300/s300_controller.dart';
import 'package:example/screens/set1/s300/s300_screen.dart';
import 'package:example/screens/set1/s400/s400_controller.dart';
import 'package:example/screens/set1/s400/s400_screen.dart';
import 'package:example/screens/set2/s500/s500_controller.dart';
import 'package:example/screens/set2/s500/s500_screen.dart';
import 'package:example/screens/set2/s600/s600_controller.dart';
import 'package:example/screens/set2/s600/s600_screen.dart';
import 'package:example/screens/set2/s700/s700_controller.dart';
import 'package:example/screens/set2/s700/s700_screen.dart';
import 'package:example/screens/set2/s800/s800_controller.dart';
import 'package:example/screens/set2/s800/s800_screen.dart';
import 'package:example/screens/splash_screen/splash_controller.dart';
import 'package:example/screens/splash_screen/splash_screen.dart';
import 'package:rubigo_router/rubigo_router.dart';

// All screens are defined here.
enum Screens {
  splashScreen,
  s100,
  s200,
  s300,
  s400,
  s500,
  s600,
  s700,
  s800,
}

// All available screens are defined here.
final ListOfRubigoScreens<Screens> availableScreens = [
  RubigoScreen(
    Screens.splashScreen,
    SplashScreen(),
    () => holder.getOrCreate(SplashController.new),
  ),
  RubigoScreen(
    Screens.s100,
    S100Screen(),
    () => holder.getOrCreate(S100Controller.new),
  ),
  RubigoScreen(
    Screens.s200,
    S200Screen(),
    () => holder.getOrCreate(S200Controller.new),
  ),
  RubigoScreen(
    Screens.s300,
    S300Screen(),
    () => holder.getOrCreate(S300Controller.new),
  ),
  RubigoScreen(
    Screens.s400,
    const S400Screen(),
    () => holder.getOrCreate(S400Controller.new),
  ),
  RubigoScreen(
    Screens.s500,
    S500Screen(),
    () => holder.getOrCreate(S500Controller.new),
  ),
  RubigoScreen(
    Screens.s600,
    S600Screen(),
    () => holder.getOrCreate(S600Controller.new),
  ),
  RubigoScreen(
    Screens.s700,
    S700Screen(),
    () => holder.getOrCreate(S700Controller.new),
  ),
  RubigoScreen(
    Screens.s800,
    const S800Screen(),
    () => holder.getOrCreate(S800Controller.new),
  ),
];
