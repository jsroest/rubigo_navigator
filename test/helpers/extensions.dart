import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rubigo_router/rubigo_router.dart';

extension ExtensionOnListOfRubigoScreen on List<RubigoScreen> {
  List<MaterialPage<void>> toListOfMaterialPage() =>
      map((e) => e.toMaterialPage()).toList();

  List<CupertinoPage<void>> toListOfCupertinoPage() =>
      map((e) => e.toCupertinoPage()).toList();
}
