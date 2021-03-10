import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:flutter_rubigo_navigator/pages/page_enum.dart';
import 'package:flutter_rubigo_navigator/pages/s030_sub_page/s030_controller.dart';
import 'package:flutter_rubigo_navigator/widgets/breadcrumbs.dart';
import 'package:rubigo_navigator/rubigo.dart';

class S030SubPage extends RubigoPage<Pages, S030Controller> {
  S030SubPage(ChangeNotifierProvider<S030Controller> controllerProvider)
      : super(controllerProvider);

  static RubigoMaterialPage<Pages, S030SubPage> get page =>
      createPage(S030SubPage(s030ControllerProvider));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sub page'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BreadCrumbs(page: S030SubPage.page),
          FlatButton(
            child: Text('Remove page 2'),
            onPressed: context.read(controllerProvider).doContinue,
          )
        ],
      ),
    );
  }
}
