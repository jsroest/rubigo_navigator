import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_rubigo_navigator/pages/page_enum.dart';
import 'package:flutter_rubigo_navigator/pages/s010_login/s010_controller.dart';
import 'package:flutter_rubigo_navigator/widgets/breadcrumbs.dart';
import 'package:rubigo_navigator/rubigo.dart';

class S010LoginPage extends RubigoPage<Pages, S010Controller> {
  S010LoginPage(ChangeNotifierProvider<S010Controller> controllerProvider)
      : super(controllerProvider);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login page'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BreadCrumbs(page: Pages.s010Login),
          TextButton(
            child: Text('Login'),
            onPressed: context.read(controllerProvider).doContinue,
          )
        ],
      ),
    );
  }
}
