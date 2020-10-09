import 'package:flutter/widgets.dart';
import 'package:flutter_rubigo_navigator/navigator/rubigo_navigator.dart';
import 'package:flutter_rubigo_navigator/pages/s010_login/s010_login.page.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> providers = [
  ChangeNotifierProvider<RubigoNavigator>(create: (BuildContext context) {
    return RubigoNavigator(<Page>[S010LoginPage.page]);
  })
];
