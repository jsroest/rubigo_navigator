import 'package:flutter_test/flutter_test.dart';
import 'package:rubigo_router/rubigo_router.dart';

void main() {
  test(
    'RubigoHolder',
    () {
      final holder = RubigoHolder();
      final controller1 = holder.getOrCreate(_ControllerScreens1.new);
      final controller2 = _ControllerScreens2();
      holder.add(controller2);

      expect(controller1 is RubigoControllerMixin, true);
      expect(controller1 is RubigoControllerMixin<_Screens>, true);
      expect(controller1 is _ControllerScreens1, true);
      final tmp1 = holder.getOrCreate(_ControllerScreens1.new);
      expect(identical(controller1, tmp1), true);

      final tmp2 = holder.getOrCreate(_ControllerScreens2.new);
      expect(identical(controller2, tmp2), true);

      expect(identical(controller1, controller2), false);

      final newController1 = _ControllerScreens1();
      holder.add(newController1);
      final tmp3 = holder.get<_ControllerScreens1>();

      expect(identical(newController1, tmp3), true);

      final tmp4 = holder.getOrCreate(_ControllerScreens1.new);

      expect(identical(tmp3, tmp4), true);
    },
  );
}

enum _Screens {
  //ignore: unused_field
  screen1,
  //ignore: unused_field
  screen2,
}

class _ControllerScreens1 with RubigoControllerMixin<_Screens> {}

class _ControllerScreens2 with RubigoControllerMixin<_Screens> {}
