import 'package:flutter/material.dart';
import 'package:flutter_app_navigator2_test/classes/material_page_ex.dart';
import 'package:flutter_app_navigator2_test/pages/s010_login/services/s010_providers.dart';
import 'package:flutter_app_navigator2_test/pages/s010_login/services/s010_state.dart';
import 'package:flutter_app_navigator2_test/widgets/breadcrumbs.dart';
import 'package:provider/provider.dart';

class S010LoginPage extends StatelessWidget {
  static MaterialPageEx get page {
    return MaterialPageEx<S010LoginPage>(
      builder: (_) => S010LoginPage(),
      name: 'S010LoginPage',
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: Builder(builder: (BuildContext context) {
        var state = context.watch<S010State>();
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
                onPressed: state.doContinue,
              )
            ],
          ),
        );
      }),
    );
  }
}
