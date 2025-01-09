import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rubigo_navigator/src/rubigo_screen.dart';

extension ExtensionOnRubigoScreen on RubigoScreen {
  MaterialPage<void> toMaterialPage() => MaterialPage(
        key: pageKey,
        child: screenWidget,
      );

  CupertinoPage<void> toCupertinoPage() => CupertinoPage(
        key: pageKey,
        child: screenWidget,
      );
}
