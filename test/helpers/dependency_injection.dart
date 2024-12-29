import 'package:get_it/get_it.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';

import 'screens/screens.dart';

final getIt = GetIt.instance..allowReassignment = true;

RubigoRouter<Screens> get rubigoRouter => getIt.get<RubigoRouter<Screens>>();
