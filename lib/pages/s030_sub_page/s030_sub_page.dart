import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_rubigo_navigator/classes/material_page_ex.dart';
import 'package:flutter_rubigo_navigator/pages/s030_sub_page/s030_controller.dart';
import 'package:flutter_rubigo_navigator/widgets/breadcrumbs.dart';

class S030SubPage extends StatelessWidget {
  const S030SubPage({Key key, this.id}) : super(key: key);

  static MaterialPageEx<S030SubPage> page(S030 id) =>
      createPage(S030SubPage(id: id));

  final S030 id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sub page (${id.toString()})'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BreadCrumbs(page: S030SubPage.page(id)),
          FlatButton(
            child: Text('Remove page 2'),
            onPressed: context.read(s030ControllerProvider(id)).doContinue,
          )
        ],
      ),
    );
  }
}
