import 'package:flutter/material.dart';
import 'package:rubigo_router/rubigo_router.dart';

// A dialog that let the user choose between Yes and No.
// This dialog is pushed with the standard Flutter Navigator.
Future<bool> areYouSure(RubigoRouter rubigoRouter) async {
  try {
    // Disable the busyService temporarily, otherwise the user is not able to
    // interact with the dialog.
    rubigoRouter.busyService.enabled = false;

    /// Be aware that dialogs are pushed on the Flutter page stack as pageless
    /// routes. They are not pushed on the screen stack as managed my the
    /// [RubigoRouter]
    final result = await showDialog<bool>(
      context: rubigoRouter.navigatorKey.currentContext!,
      builder: (context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          actions: [
            ElevatedButton(
              //This pop is done directly on Flutters page stack.
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Yes'),
            ),
            ElevatedButton(
              //This pop is done directly on Flutters page stack.
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
          ],
        );
      },
    );
    //Return false when the user touches outside the dialog.
    return result ?? false;
  } finally {
    //Don't forget to enable the busy service again.
    rubigoRouter.busyService.enabled = true;
  }
}
