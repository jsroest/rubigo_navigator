import 'package:flutter/widgets.dart';
import 'package:flutter_rubigo_navigator/navigator/rubigo_navigator.dart';
import 'package:flutter_rubigo_navigator/pages/s010_login/services/s010_state.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> providers = [
  ChangeNotifierProvider<S010State>(
    create: (BuildContext context) {
      return S010State(
        context.read<RubigoNavigator>(),
      );
    },
  ),
];
