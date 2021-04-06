import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_rubigo_navigator/pages/pages.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ProviderScope(
      child: RubigoApp<Pages>(
        controllers: controllers,
      ),
    ),
  );
}
