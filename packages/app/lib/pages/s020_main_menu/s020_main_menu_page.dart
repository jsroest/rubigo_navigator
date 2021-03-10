import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:flutter_rubigo_navigator/pages/page_enum.dart';
import 'package:flutter_rubigo_navigator/pages/s020_main_menu/s020_controller.dart';
import 'package:flutter_rubigo_navigator/widgets/breadcrumbs.dart';
import 'package:rubigo_navigator/rubigo.dart';

class S020MainMenuPage extends RubigoPage<Pages, S020Controller> {
  S020MainMenuPage(ChangeNotifierProvider<S020Controller> controllerProvider)
      : super(controllerProvider);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main menu'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BreadCrumbs(page: Pages.S020),
          FlatButton(
            child: Text('To sub page'),
            onPressed: context.read(controllerProvider).doContinue,
          )
        ],
      ),
    );
  }
}
