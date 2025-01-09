import 'package:rubigo_navigator/src/rubigo_screen.dart';

/// A list of RubigoScreen.
typedef ListOfRubigoScreens<SCREEN_ID extends Enum>
    = List<RubigoScreen<SCREEN_ID>>;

/// A function to log navigation events, using your favorite logger
typedef LogNavigation = Future<void> Function(String message);
