import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_rubigo_navigator/classes/material_page_ex.dart';
import 'package:flutter_rubigo_navigator/pages/s020_main_menu/s020_controller.dart';
import 'package:flutter_rubigo_navigator/widgets/breadcrumbs.dart';

class S020MainMenuPage extends StatelessWidget {
  static MaterialPageEx<S020MainMenuPage> get page =>
      createPage(S020MainMenuPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main menu'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BreadCrumbs(page: S020MainMenuPage.page),
          FlatButton(
            child: Text('To sub page'),
            onPressed: context.read(s020ControllerProvider).doContinue,
          )
        ],
      ),
    );
  }
}
