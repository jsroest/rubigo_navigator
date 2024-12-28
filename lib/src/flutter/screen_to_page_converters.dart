import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';

extension FlutterExtensionOnListOfRubigoScreens<SCREEN_ID extends Enum>
    on ListOfRubigoScreens<SCREEN_ID> {
  List<MaterialPage<void>> toMaterialPages() => map(
        (e) => MaterialPage<void>(
          key: e.pageKey,
          child: e.screenWidget,
        ),
      ).toList();

  List<CupertinoPage<void>> toCupertinoPages() => map(
        (e) => CupertinoPage<void>(
          key: e.pageKey,
          child: e.screenWidget,
        ),
      ).toList();
}
