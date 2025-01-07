import 'package:rubigo_navigator/rubigo_navigator.dart';

import 'screens/mocks/mock_controller.dart';
import 'screens/s100/s100_controller.dart';
import 'screens/s100/s100_screen.dart';
import 'screens/s200/s200_controller.dart';
import 'screens/s200/s200_controller_may_pop_pop.dart';
import 'screens/s200/s200_controller_may_pop_push.dart';
import 'screens/s200/s200_controller_may_pop_returns_false.dart';
import 'screens/s200/s200_controller_on_top_push_and_pop.dart';
import 'screens/s200/s200_controller_will_show_pop.dart';
import 'screens/s200/s200_controller_will_show_push.dart';
import 'screens/s200/s200_screen.dart';
import 'screens/s300/s300_controller.dart';
import 'screens/s300/s300_screen.dart';
import 'screens/s500/s500_controller.dart';
import 'screens/s500/s500_screen.dart';
import 'screens/s600/s600_controller.dart';
import 'screens/s600/s600_screen.dart';
import 'screens/s700/s700_controller.dart';
import 'screens/s700/s700_screen.dart';
import 'screens/screens.dart';
import 'screens/splash_screen/splash_controller.dart';
import 'screens/splash_screen/splash_screen.dart';

RubigoScreen<Screens> getSplashScreen(
  RubigoControllerHolder<MockController<Screens>> holder,
) {
  return RubigoScreen(
    Screens.splashScreen,
    SplashScreen(),
    () => holder.get(SplashController.new),
  );
}

RubigoScreen<Screens> getS100Screen(
  RubigoControllerHolder<MockController<Screens>> holder,
) {
  return RubigoScreen(
    Screens.s100,
    S100Screen(),
    () => holder.get(S100Controller.new),
  );
}

RubigoScreen<Screens> getS200Screen(
  RubigoControllerHolder<MockController<Screens>> holder,
) {
  return RubigoScreen(
    Screens.s200,
    S200Screen(),
    () => holder.get(S200Controller.new),
  );
}

RubigoScreen<Screens> getS200ScreenOnTopPushAndPop(
  RubigoControllerHolder<MockController<Screens>> holder,
) {
  return RubigoScreen(
    Screens.s200,
    S200Screen(),
    () => holder.get(S200ControllerOnTopPushAndPop.new),
  );
}

RubigoScreen<Screens> getS200ScreenWillShowPush(
  RubigoControllerHolder<MockController<Screens>> holder,
) {
  return RubigoScreen(
    Screens.s200,
    S200Screen(),
    () => holder.get(S200ControllerWillShowPush.new),
  );
}

RubigoScreen<Screens> getS200ScreenWillShowPop(
  RubigoControllerHolder<MockController<Screens>> holder,
) {
  return RubigoScreen(
    Screens.s200,
    S200Screen(),
    () => holder.get(S200ControllerWillShowPop.new),
  );
}

RubigoScreen<Screens> getS200ScreenMayPopPop(
  RubigoControllerHolder<MockController<Screens>> holder,
) {
  return RubigoScreen(
    Screens.s200,
    S200Screen(),
    () => holder.get(S200ControllerMayPopPop.new),
  );
}

RubigoScreen<Screens> getS200ScreenMayPopPush(
  RubigoControllerHolder<MockController<Screens>> holder,
) {
  return RubigoScreen(
    Screens.s200,
    S200Screen(),
    () => holder.get(S200ControllerMayPopPush.new),
  );
}

RubigoScreen<Screens> getS200ScreenMayPopReturnsFalse(
  RubigoControllerHolder<MockController<Screens>> holder,
) {
  return RubigoScreen(
    Screens.s200,
    S200Screen(),
    () => holder.get(S200ControllerMayPopReturnsFalse.new),
  );
}

RubigoScreen<Screens> getS300Screen(
  RubigoControllerHolder<MockController<Screens>> holder,
) {
  return RubigoScreen(
    Screens.s300,
    S300Screen(),
    () => holder.get(S300Controller.new),
  );
}

RubigoScreen<Screens> getS500Screen(
  RubigoControllerHolder<MockController<Screens>> holder,
) {
  return RubigoScreen(
    Screens.s500,
    S500Screen(),
    () => holder.get(S500Controller.new),
  );
}

RubigoScreen<Screens> getS600Screen(
  RubigoControllerHolder<MockController<Screens>> holder,
) {
  return RubigoScreen(
    Screens.s600,
    S600Screen(),
    () => holder.get(S600Controller.new),
  );
}

RubigoScreen<Screens> getS700Screen(
  RubigoControllerHolder<MockController<Screens>> holder,
) {
  return RubigoScreen(
    Screens.s700,
    S700Screen(),
    () => holder.get(S700Controller.new),
  );
}
