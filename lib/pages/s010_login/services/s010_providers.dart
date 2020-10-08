import 'package:flutter/widgets.dart';
import 'package:flutter_app_navigator2_test/classes/page_stack.dart';
import 'package:flutter_app_navigator2_test/pages/s010_login/services/s010_state.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> providers = [
  ChangeNotifierProvider<S010State>(
    create: (BuildContext context) {
      return S010State(
        context.read<PageStack>(),
      );
    },
  ),
];
