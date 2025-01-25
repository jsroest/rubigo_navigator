import 'package:flutter/material.dart';
import 'package:rubigo_router/rubigo_router.dart';

/// Use this function on [AppBar.leading] to show a standard BackButton (when
/// appropriate) that delegates onPressed to the [RubigoRouter]'s
/// [Ui.handleBackEvent].
Widget? rubigoBackButton(
  BuildContext context,
  RubigoRouter rubigoRouter,
) {
  return ModalRoute.canPopOf(context) ?? false
      ? BackButton(onPressed: rubigoRouter.ui.handleBackEvent)
      : null;
}
