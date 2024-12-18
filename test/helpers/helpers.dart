import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

checkPages<PAGE_TYPE extends Page>({
  required List<Page> pages,
  required List<Widget> screens,
}) {
  //We expect the number of items in the list to be equal
  final nrOfPages = pages.length;
  final nrOfScreens = screens.length;
  if (nrOfPages != nrOfScreens) {
    throw ArgumentError(
      'The number of pages ($nrOfPages) is not equal to the number of screens ($nrOfScreens).',
    );
  }
  if (nrOfPages > 0) {
    for (final page in pages) {
      if (page is! PAGE_TYPE) {
        throw ArgumentError(
          'Some or all pages are not of type ${PAGE_TYPE.toString()}.',
        );
      }
    }
  }
  for (int index = 0; index < pages.length; index++) {
    final page = pages[index];
    final screen = screens[index];
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
