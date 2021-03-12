import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:flutter_rubigo_navigator/pages/page_enum.dart';
import 'package:flutter_rubigo_navigator/pages/s999_settings/s999_controller.dart';
import 'package:rubigo_navigator/rubigo.dart';

class S999SettingsPage extends RubigoPage<Pages, S999Controller> {
  S999SettingsPage(ChangeNotifierProvider<S999Controller> controllerProvider)
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
