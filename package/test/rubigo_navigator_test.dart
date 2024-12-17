import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';
import 'package:rubigo_navigator/src/rubigo_navigator.dart';

enum Pages {
  page1,
  page2,
  page3,
}

void main() {
  test(
    'create a navigator',
    () {
      final delegate = RubigoDelegate<Pages>(
        splashPage: MaterialPage(
          child: Container(),
        ),
      );
      delegate.push(Pages.page1);
    },
  );

  test('adds one to input values', () {
    final calculator = Calculator();
    expect(calculator.addOne(2), 3);
    expect(calculator.addOne(-7), -6);
    expect(calculator.addOne(0), 1);
  });
}
