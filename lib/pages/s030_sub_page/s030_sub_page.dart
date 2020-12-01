import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_rubigo_navigator/classes/material_page_ex.dart';
import 'package:flutter_rubigo_navigator/pages/s030_sub_page/s030_state.dart';
import 'package:flutter_rubigo_navigator/widgets/breadcrumbs.dart';

class S030SubPage extends StatelessWidget {
  // static Route<void> get route => createRoute(S030CreateOrderPage());
  //
  // MaterialPageRoute<T> createRoute<T>(Widget widget) => MaterialPageRoute(
  //     builder: (context) => widget,
  //     settings: RouteSettings(name: widget.toString()));

  static MaterialPageEx get page {
    return MaterialPageEx<S030SubPage>(
      child: S030SubPage(),
    );
  }

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
            onPressed: context.read(s030ControllerProvider).doContinue,
          )
        ],
      ),
    );
  }
}
