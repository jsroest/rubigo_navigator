import 'package:example/screens/set1/s100/s100_controller.dart';
import 'package:example/screens/set1/s100/s100_screen.dart';
import 'package:example/screens/set1/s200/s200_controller.dart';
import 'package:example/screens/set1/s200/s200_screen.dart';
import 'package:example/screens/set1/s300/s300_controller.dart';
import 'package:example/screens/set1/s300/s300_screen.dart';
import 'package:example/screens/set2/s500/s500_controller.dart';
import 'package:example/screens/set2/s500/s500_screen.dart';
import 'package:example/screens/set2/s600/s600_controller.dart';
import 'package:example/screens/set2/s600/s600_screen.dart';
import 'package:example/screens/set2/s700/s700_controller.dart';
import 'package:example/screens/set2/s700/s700_screen.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';

enum Screens {
  s100,
  s200,
  s300,
  s500,
  s600,
  s700,
}

final ListOfRubigoScreens<Screens> availableScreens = [
  RubigoScreen(
    Screens.s100,
    S100Screen(),
    S100Controller(),
  ),
  RubigoScreen(
    Screens.s200,
    S200Screen(),
    S200Controller(),
  ),
  RubigoScreen(
    Screens.s300,
    S300Screen(),
    S300Controller(),
  ),
  RubigoScreen(
    Screens.s500,
    S500Screen(),
    S500Controller(),
  ),
  RubigoScreen(
    Screens.s600,
    S600Screen(),
    S600Controller(),
  ),
  RubigoScreen(
    Screens.s700,
    S700Screen(),
    S700Controller(),
  ),
];
