import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';

/// Extensions on [RubigoScreen]
extension ExtensionOnRubigoScreen on RubigoScreen {
  /// Converts a [RubigoScreen] to a [MaterialPage]
  MaterialPage<void> toMaterialPage() => MaterialPage(
        key: pageKey,
        child: screenWidget,
      );

  /// Converts a [RubigoScreen] to a [CupertinoPage]
  CupertinoPage<void> toCupertinoPage() => CupertinoPage(
        key: pageKey,
        child: screenWidget,
      );
}
