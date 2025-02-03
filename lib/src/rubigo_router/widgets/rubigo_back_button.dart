import 'package:flutter/material.dart';
import 'package:rubigo_router/rubigo_router.dart';

/// Use this function for [AppBar.leading] to show a standard BackButton that
/// delegates onPressed to the [RubigoRouter.ui].pop function.
Widget? rubigoBackButton(
  BuildContext context,
  RubigoRouter rubigoRouter,
) {
  return ModalRoute.canPopOf(context) ?? false
      ? BackButton(onPressed: rubigoRouter.ui.pop)
      : null;
}
