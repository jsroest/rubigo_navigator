import 'package:flutter/widgets.dart';
import 'package:flutter_app_navigator2_test/classes/page_stack.dart';
import 'package:flutter_app_navigator2_test/pages/s030_sub_page/services/s030_state.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> providers = [
  Provider<S030State>(
    create: (BuildContext context) {
      return S030State(
        context.read<PageStack>(),
      );
    },
  ),
];
