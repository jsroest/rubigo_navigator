import 'package:flutter/material.dart';
import 'package:flutter_rubigo_navigator/classes/material_page_ex.dart';
import 'package:flutter_rubigo_navigator/pages/s020_main_menu/services/s020_providers.dart';
import 'package:flutter_rubigo_navigator/pages/s020_main_menu/services/s020_state.dart';
import 'package:flutter_rubigo_navigator/widgets/breadcrumbs.dart';
import 'package:provider/provider.dart';

class S020MainMenuPage extends StatelessWidget {
  static MaterialPageEx get page {
    return MaterialPageEx<S020MainMenuPage>(
      child: S020MainMenuPage(),
      name: 'S020MainMenuPage',
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: Builder(builder: (BuildContext context) {
        var state = context.watch<S020State>();
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
                onPressed: state.doContinue,
              )
            ],
          ),
        );
      }),
    );
  }
}
