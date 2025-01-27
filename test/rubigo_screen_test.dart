import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rubigo_router/rubigo_router.dart';

import 'screens/screens.dart';

void main() {
  test(
    'Test rubigo screen equality and hashcode',
    () {
      final screen1 = RubigoScreen(Screens.s100, Container(), Object.new);
      final screen2 = RubigoScreen(Screens.s100, Container(), Object.new);
      final screen3 = RubigoScreen(Screens.s200, Container(), Object.new);
      expect(screen1, screen2);
      expect(screen1.hashCode, screen2.hashCode);
      expect(screen2, isNot(screen3));
      expect(screen2, isNot(screen3.hashCode));
    },
  );
}
