import 'package:demo_rubigo_navigator/screens/s100/s100_controller.dart';
import 'package:demo_rubigo_navigator/screens/s100/s100_screen.dart';
import 'package:demo_rubigo_navigator/screens/s200/s200_controller.dart';
import 'package:demo_rubigo_navigator/screens/s200/s200_screen.dart';
import 'package:demo_rubigo_navigator/screens/s300/s300_controller.dart';
import 'package:demo_rubigo_navigator/screens/s300/s300_screen.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';

enum Screens {
  s100,
  s200,
  s300,
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
];
