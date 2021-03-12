import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:flutter_rubigo_navigator/pages/page_enum.dart';
import 'package:flutter_rubigo_navigator/pages/s010_main_menu/s010_controller.dart';
import 'package:rubigo_navigator/rubigo.dart';

class S010MainMenuPage extends RubigoPage<Pages, S010Controller> {
  S010MainMenuPage(ChangeNotifierProvider<S010Controller> controllerProvider)
      : super(controllerProvider);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Menu'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          ListTile(
            leading: Icon(Icons.check),
            title: Text('Quality Control'),
            onTap: context.read(controllerProvider).onQualityControlTap,
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: context.read(controllerProvider).onSettingsTap,
          )
        ],
      ),
    );
  }
}
