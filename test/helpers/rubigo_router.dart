import 'package:get_it/get_it.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';

import 'screens/screens.dart';

RubigoRouter<Screens> get rubigoRouter =>
    GetIt.instance.get<RubigoRouter<Screens>>();
