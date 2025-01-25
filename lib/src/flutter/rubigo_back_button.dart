import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rubigo_router/rubigo_router.dart';

/// Use this function on [AppBar.leading] to show a standard BackButton (when
/// appropriate) that delegates onPressed to [RubigoRouter.handleBackEvent].
Widget? rubigoBackButton(
  BuildContext context,
  RubigoRouter rubigoRouter,
) {
  final showBackButton = ModalRoute.canPopOf(context) ?? false;
  final screenId = rubigoRouter.screens.value.last.screenId;

  return showBackButton
      ? BackButton(
          onPressed: () => unawaited(rubigoRouter.handleBackEvent(screenId)),
        )
      : null;
}
