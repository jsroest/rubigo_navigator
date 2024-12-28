import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';

List<Page<dynamic>> screensToMaterialPages<SCREEN_ID extends Enum>(
  List<RubigoScreen<SCREEN_ID>> screens,
) {
  return screens
      .map(
        (e) => MaterialPage<void>(
          key: e.pageKey,
          child: e.screenWidget,
        ),
      )
      .toList();
}

List<Page<dynamic>> screensToCupertinoPages<SCREEN_ID extends Enum>(
  List<RubigoScreen<SCREEN_ID>> screens,
) {
  return screens
      .map(
        (e) => CupertinoPage<void>(
          key: e.pageKey,
          child: e.screenWidget,
        ),
      )
      .toList();
}
