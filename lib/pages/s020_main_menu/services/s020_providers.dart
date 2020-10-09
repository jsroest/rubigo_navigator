import 'package:flutter/widgets.dart';
import 'package:flutter_rubigo_navigator/classes/page_stack.dart';
import 'package:flutter_rubigo_navigator/pages/s020_main_menu/services/s020_state.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> providers = [
  Provider<S020State>(
    create: (BuildContext context) {
      return S020State(
        context.read<PageStack>(),
      );
    },
  ),
];
