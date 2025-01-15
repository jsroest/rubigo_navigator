import 'package:rubigo_router/rubigo_router.dart';

import 'screens/s100/s100_controller.dart';
import 'screens/s100/s100_screen.dart';
import 'screens/s200/s200_controller.dart';
import 'screens/s200/s200_controller_delay_in_on_top.dart';
import 'screens/s200/s200_controller_may_pop_returns_false.dart';
import 'screens/s200/s200_controller_on_top_push_and_pop.dart';
import 'screens/s200/s200_controller_will_show_pop.dart';
import 'screens/s200/s200_controller_will_show_push.dart';
import 'screens/s200/s200_screen.dart';
import 'screens/s300/s300_controller.dart';
import 'screens/s300/s300_screen.dart';
import 'screens/s400/s400_controller.dart';
import 'screens/s400/s400_screen.dart';
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
  RubigoHolder holder,
) {
  return RubigoScreen(
    Screens.splashScreen,
    SplashScreen(),
    () => holder.getOrCreate<SplashController>(SplashController.new),
  );
}

RubigoScreen<Screens> getS100Screen(
  RubigoHolder holder,
) {
  return RubigoScreen(
    Screens.s100,
    S100Screen(),
    () => holder.getOrCreate(S100Controller.new),
  );
}

RubigoScreen<Screens> getS200Screen(
  RubigoHolder holder,
) {
  return RubigoScreen(
    Screens.s200,
    S200Screen(),
    () => holder.getOrCreate(S200Controller.new),
  );
}

RubigoScreen<Screens> getS200ScreenDelayInOnTop(
  RubigoHolder holder,
) {
  return RubigoScreen(
    Screens.s200,
    S200Screen(),
    () => holder.getOrCreate(S200ControllerDelayInOnTop.new),
  );
}

RubigoScreen<Screens> getS200ScreenOnTopPushAndPop(
  RubigoHolder holder,
) {
  return RubigoScreen(
    Screens.s200,
    S200Screen(),
    () => holder.getOrCreate(S200ControllerOnTopPushAndPop.new),
  );
}

RubigoScreen<Screens> getS200ScreenWillShowPush(
  RubigoHolder holder,
) {
  return RubigoScreen(
    Screens.s200,
    S200Screen(),
    () => holder.getOrCreate(S200ControllerWillShowPush.new),
  );
}

RubigoScreen<Screens> getS200ScreenWillShowPop(
  RubigoHolder holder,
) {
  return RubigoScreen(
    Screens.s200,
    S200Screen(),
    () => holder.getOrCreate(S200ControllerWillShowPop.new),
  );
}

RubigoScreen<Screens> getS200ScreenMayPopReturnsFalse(
  RubigoHolder holder,
) {
  return RubigoScreen(
    Screens.s200,
    S200Screen(),
    () => holder.getOrCreate(S200ControllerMayPopReturnsFalse.new),
  );
}

RubigoScreen<Screens> getS300Screen(
  RubigoHolder holder,
) {
  return RubigoScreen(
    Screens.s300,
    S300Screen(),
    () => holder.getOrCreate(S300Controller.new),
  );
}

RubigoScreen<Screens> getS400Screen(
  RubigoHolder holder,
) {
  return RubigoScreen(
    Screens.s400,
    S400Screen(),
    () => holder.getOrCreate(S400Controller.new),
  );
}

RubigoScreen<Screens> getS500Screen(
  RubigoHolder holder,
) {
  return RubigoScreen(
    Screens.s500,
    S500Screen(),
    () => holder.getOrCreate(S500Controller.new),
  );
}

RubigoScreen<Screens> getS600Screen(
  RubigoHolder holder,
) {
  return RubigoScreen(
    Screens.s600,
    S600Screen(),
    () => holder.getOrCreate(S600Controller.new),
  );
}

RubigoScreen<Screens> getS700Screen(
  RubigoHolder holder,
) {
  return RubigoScreen(
    Screens.s700,
    S700Screen(),
    () => holder.getOrCreate(S700Controller.new),
  );
}
