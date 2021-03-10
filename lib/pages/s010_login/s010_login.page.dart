import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_rubigo_navigator/navigator/rubigo_material_page.dart';
import 'package:flutter_rubigo_navigator/navigator/rubigo_page.dart';
import 'package:flutter_rubigo_navigator/pages/page_enum.dart';
import 'package:flutter_rubigo_navigator/pages/s010_login/s010_controller.dart';
import 'package:flutter_rubigo_navigator/widgets/breadcrumbs.dart';

class S010LoginPage extends RubigoPage<Pages, S010Controller> {
  S010LoginPage(ChangeNotifierProvider<S010Controller> controllerProvider)
      : super(controllerProvider);

  static RubigoMaterialPage<Pages, S010LoginPage> get page =>
      createPage(S010LoginPage(s010ControllerProvider));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login page'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BreadCrumbs(page: S010LoginPage.page),
          FlatButton(
            child: Text('Login'),
            onPressed: context.read(controllerProvider).doContinue,
          )
        ],
      ),
    );
  }
}
