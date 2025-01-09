import 'package:flutter/material.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';

Future<bool> areYouSure(RubigoRouter rubigoRouter) async {
  final result = await showDialog<bool>(
    context: rubigoRouter.navigatorKey.currentContext!,
    builder: (context) {
      return AlertDialog(
        title: const Text('Are you sure?'),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
        ],
      );
    },
  );
  return result ?? false;
}
