import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:flutter_rubigo_navigator/navigator/rubigo_controller.dart';

abstract class RubigoPage<U extends RubigoController> extends StatelessWidget {
  const RubigoPage(this.state, {Key key}) : super(key: key);

  final ChangeNotifierProvider<U> state;
}
