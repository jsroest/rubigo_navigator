import 'package:flutter/material.dart';
import 'package:flutter_app_navigator2_test/classes/material_page_ex.dart';
import 'package:flutter_app_navigator2_test/pages/s030_sub_page/services/s030_providers.dart';
import 'package:flutter_app_navigator2_test/pages/s030_sub_page/services/s030_state.dart';
import 'package:flutter_app_navigator2_test/widgets/breadcrumbs.dart';
import 'package:provider/provider.dart';

class S030SubPage extends StatelessWidget {
  static MaterialPageEx get page {
    return MaterialPageEx<S030SubPage>(
      builder: (_) => S030SubPage(),
      name: 'S030SubPage',
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: Builder(builder: (BuildContext context) {
        var state = context.watch<S030State>();
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
                onPressed: state.doContinue,
              )
            ],
          ),
        );
      }),
    );
  }
}
