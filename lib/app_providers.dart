import 'package:flutter/widgets.dart';
import 'package:flutter_rubigo_navigator/classes/page_stack.dart';
import 'package:flutter_rubigo_navigator/pages/s010_login/s010_login.page.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> providers = [
  ChangeNotifierProvider<PageStack>(
    create: (BuildContext context) {
      return PageStack([S010LoginPage.page]);
    },
  ),
];
