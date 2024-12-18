import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/helpers.dart';
import 'helpers/screens/s100/s100_screen.dart';
import 'helpers/screens/s200/s200_screen.dart';

void main() {
  test(
    'Valid Material pages',
    () {
      final s100Screen = S100Screen();
      final s200Screen = S200Screen();
      final pages = <MaterialPage<void>>[
        MaterialPage(child: s100Screen),
        MaterialPage(child: s200Screen),
      ];
      final screens = <Widget>[
        s100Screen,
        s200Screen,
      ];
      checkPages(pages: pages, screens: screens);
    },
  );

  test(
    'Valid Cupertino pages',
    () {
      final s100Screen = S100Screen();
      final s200Screen = S200Screen();
      final pages = <CupertinoPage<void>>[
        CupertinoPage(child: s100Screen),
        CupertinoPage(child: s200Screen),
      ];
      final screens = <Widget>[
        s100Screen,
        s200Screen,
      ];
      checkPages(pages: pages, screens: screens);
    },
  );

  test(
    'Number of pages do not match number of screens',
    () {
      final s100Screen = S100Screen();
      final s200Screen = S200Screen();
      final pages = <MaterialPage<void>>[
        MaterialPage(child: s100Screen),
      ];
      final screens = <Widget>[
        s100Screen,
        s200Screen,
      ];
      expect(
        () => checkPages<MaterialPage<void>>(
          pages: pages,
          screens: screens,
        ),
        throwsA(
          predicate(
            (e) =>
                e is ArgumentError &&
                e.message ==
                    'The number of pages (1) is not equal to the number of screens (2).',
          ),
        ),
      );
    },
  );

  test(
    'Some or all pages are not of the same type',
    () {
      final s100Screen = S100Screen();
      final s200Screen = S200Screen();
      final pages = <Page<void>>[
        MaterialPage(child: s100Screen),
        CupertinoPage(child: s200Screen),
      ];
      final screens = <Widget>[
        s100Screen,
        s200Screen,
      ];
      expect(
        () => checkPages<MaterialPage<void>>(
          pages: pages,
          screens: screens,
        ),
        throwsA(
          predicate(
            (e) =>
                e is ArgumentError &&
                e.message ==
                    'Some or all pages are not of type MaterialPage<void>.',
          ),
        ),
      );
    },
  );

  test(
    'The list of Pages does not match the list of Screens',
    () {
      final s100Screen = S100Screen();
      final s200Screen = S200Screen();
      final pages = <Page<void>>[
        MaterialPage(child: s100Screen),
        MaterialPage(child: s200Screen),
      ];
      final screens = <Widget>[
        s200Screen,
        s100Screen,
      ];
      expect(
        () => checkPages<MaterialPage<void>>(
          pages: pages,
          screens: screens,
        ),
        throwsA(
          predicate(
            (e) =>
                e is ArgumentError &&
                e.message ==
                    'The list of Pages does not match the list of Screens',
          ),
        ),
      );
    },
  );
}
