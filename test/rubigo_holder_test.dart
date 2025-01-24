import 'package:flutter_test/flutter_test.dart';
import 'package:rubigo_router/rubigo_router.dart';

void main() {
  test(
    'RubigoHolder',
    () {
      final holder = RubigoHolder();
      final controller1 = holder.getOrCreate(ControllerScreens1.new);
      final controller2 = holder.getOrCreate(ControllerScreens2.new);

      expect(controller1 is RubigoControllerMixin, true);
      expect(controller1 is RubigoControllerMixin<Screens>, true);
      expect(controller1 is ControllerScreens1, true);
      final tmp1 = holder.getOrCreate(ControllerScreens1.new);
      expect(identical(controller1, tmp1), true);

      expect(controller2 is RubigoControllerMixin, true);
      expect(controller2 is RubigoControllerMixin<Screens>, true);
      expect(controller2 is ControllerScreens2, true);
      final tmp2 = holder.getOrCreate(ControllerScreens2.new);
      expect(identical(controller2, tmp2), true);

      expect(identical(controller1, controller2), false);
    },
  );
}

enum Screens {
  screen1,
  screen2,
}

class ControllerScreens1 with RubigoControllerMixin<Screens> {}

class ControllerScreens2 with RubigoControllerMixin<Screens> {}
