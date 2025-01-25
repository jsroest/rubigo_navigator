import 'package:flutter/material.dart';
import 'package:rubigo_router/rubigo_router.dart';

/// Use this function on [AppBar.leading] to show a standard BackButton (when
/// appropriate) that delegates onPressed to [RubigoRouter.handleBackEvent].
Widget? rubigoBackButton(
  BuildContext context,
  RubigoRouter rubigoRouter,
) {
  return ModalRoute.canPopOf(context) ?? false
      ? BackButton(onPressed: rubigoRouter.handleBackEvent)
      : null;
}
