import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rubigo_navigator/src/rubigo_screen.dart';

extension ExtensionOnListOfRubigoScreenBase on List<RubigoScreen> {
  List<MaterialPage<void>> toListOfMaterialPage() =>
      map((e) => e.toMaterialPage()).toList();

  List<CupertinoPage<void>> toListOfCupertinoPage() =>
      map((e) => e.toCupertinoPage()).toList();
}

extension ExtensionOnRubigoScreenBase on RubigoScreen {
  MaterialPage<void> toMaterialPage() => MaterialPage(
        key: pageKey,
        child: screenWidget,
      );

  CupertinoPage<void> toCupertinoPage() => CupertinoPage(
        key: pageKey,
        child: screenWidget,
      );
}
