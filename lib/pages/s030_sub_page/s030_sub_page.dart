import 'package:flutter/material.dart';
import 'package:flutter_rubigo_navigator/classes/material_page_ex.dart';
import 'package:flutter_rubigo_navigator/pages/s030_sub_page/services/s030_providers.dart';
import 'package:flutter_rubigo_navigator/pages/s030_sub_page/services/s030_state.dart';
import 'package:flutter_rubigo_navigator/widgets/breadcrumbs.dart';
import 'package:provider/provider.dart';

class S030SubPage extends StatelessWidget {
  static MaterialPageEx get page {
    return MaterialPageEx<S030SubPage>(
      child: S030SubPage(),
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
