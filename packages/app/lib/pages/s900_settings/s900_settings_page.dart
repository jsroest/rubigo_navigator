import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_rubigo_navigator/pages/page_enum.dart';
import 'package:flutter_rubigo_navigator/pages/s900_settings/s900_settings_controller.dart';
import 'package:rubigo_navigator/rubigo.dart';

class S900SettingsPage extends RubigoPage<Pages, S900SettingsController> {
  S900SettingsPage(
      ChangeNotifierProvider<S900SettingsController> controllerProvider)
      : super(controllerProvider);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Center(
        child: Text('Not implemented'),
      ),
    );
  }
}
