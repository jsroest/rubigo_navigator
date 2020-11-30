import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_rubigo_navigator/classes/material_page_ex.dart';
import 'package:flutter_rubigo_navigator/pages/s010_login/s010_controller.dart';
import 'package:flutter_rubigo_navigator/widgets/breadcrumbs.dart';

class S010LoginPage extends StatelessWidget {
  static MaterialPageEx get page {
    return MaterialPageEx<S010LoginPage>(
      child: S010LoginPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // var navigator = watch Prov context.read<RubigoNavigator>();
    // var state = navigator.get<S010ScreenController>();
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
            onPressed: context.read(s010ControllerProvider).doContinue,
          )
        ],
      ),
    );
  }
}
