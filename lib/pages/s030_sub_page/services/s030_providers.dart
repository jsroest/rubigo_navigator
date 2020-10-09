import 'package:flutter/widgets.dart';
import 'package:flutter_rubigo_navigator/navigator/rubigo_navigator.dart';
import 'package:flutter_rubigo_navigator/pages/s030_sub_page/services/s030_state.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> providers = [
  Provider<S030State>(
    create: (BuildContext context) {
      return S030State(
        context.read<RubigoNavigator>(),
      );
    },
  ),
];
