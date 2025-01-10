import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void checkPages({
  required List<Page<void>> actualPages,
  required List<Widget> expectedScreenWidgets,
}) {
  //We expect the number of items in the list to be equal types
  final nrOfPages = actualPages.length;
  final nrOfScreens = expectedScreenWidgets.length;
  if (nrOfPages != nrOfScreens) {
    throw ArgumentError(
      'The number of pages ($nrOfPages) is not equal to the number of screens '
      '($nrOfScreens).',
    );
  }
  final Type pageType;
  if (nrOfPages > 0) {
    pageType = actualPages[0].runtimeType;
    for (final page in actualPages) {
      if (page.runtimeType != pageType) {
        throw ArgumentError(
          'Some or all pages are not of type $pageType.',
        );
      }
    }
  }
  for (var index = 0; index < actualPages.length; index++) {
    final page = actualPages[index];
    final screen = expectedScreenWidgets[index];
    final Widget screenWidget;
    if (page is MaterialPage<void>) {
      screenWidget = page.child;
    } else if (page is CupertinoPage<void>) {
      screenWidget = page.child;
    } else {
      throw TypeError();
    }
    if (screenWidget != screen) {
      throw ArgumentError(
        'The list of Pages does not match the list of Screens',
      );
    }
  }
}
