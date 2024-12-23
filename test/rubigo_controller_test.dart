import 'package:flutter_test/flutter_test.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';

import 'helpers/screens/s100/s100_controller.dart';
import 'helpers/screens/s100/s100_screen.dart';
import 'helpers/screens/s200/s200_controller.dart';
import 'helpers/screens/s200/s200_screen.dart';
import 'helpers/screens/s300/s200_controller.dart';
import 'helpers/screens/s300/s200_screen.dart';
import 'helpers/screens/screens.dart';

ListOfRubigoScreens<Screens> createAvailableScreens() => [
      RubigoScreen(Screens.s100, S100Screen(), S100Controller()),
      RubigoScreen(Screens.s200, S200Screen(), S200Controller()),
      RubigoScreen(Screens.s300, S300Screen(), S300Controller()),
    ];

void main() {
  test('Navigator on controller is the same object', () async {
    final availableScreens = createAvailableScreens();
    final initialScreenStack = [
      Screens.s100,
    ];
    final navigator = RubigoNavigator<Screens>(
      initialScreenStack: initialScreenStack,
      availableScreens: availableScreens,
    );
    final pages = navigator.screens;
    final s100Screen = pages[0].screenWidget;
    final screenId = availableScreens.findScreenIdByScreen(s100Screen);
    final s100Controller =
        availableScreens.findSpecificController<S100Controller>(screenId);
    expect(s100Controller.navigator, navigator);
  });
}
