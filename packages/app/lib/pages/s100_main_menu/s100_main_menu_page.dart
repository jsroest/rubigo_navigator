import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_rubigo_navigator/pages/page_enum.dart';
import 'package:flutter_rubigo_navigator/pages/s100_main_menu/s100_main_menu_controller.dart';
import 'package:rubigo_navigator/rubigo.dart';

class S100MainMenuPage extends RubigoPage<Pages, S100MainMenuController> {
  S100MainMenuPage(
      ChangeNotifierProvider<S100MainMenuController> controllerProvider)
      : super(controllerProvider);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main menu'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          ListTile(
            leading: Icon(
              Icons.check_circle,
              size: 48.0,
              color: Colors.green,
            ),
            title: Text(
              'Quality control',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
            ),
            onTap: context.read(controllerProvider).onQualityControlTap,
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.settings,
              size: 48.0,
              color: Colors.blue,
            ),
            title: Text(
              'Settings',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
            ),
            onTap: context.read(controllerProvider).onSettingsTap,
          )
        ],
      ),
    );
  }
}
