import 'package:example/screens/screens.dart';
import 'package:get_it/get_it.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';

final getIt = GetIt.instance;

RubigoRouter<Screens> get rubigoRouter => getIt.get<RubigoRouter<Screens>>();

Future<void> setup() async {
  //region RubigoRouter
  await rubigoRouter.init(
    getFirstScreenAsync: () async {
      // This can be used to wire up the application. During this time a
      // Splash widget is show. When the wiring up completes, this function
      // must return the first page to navigate to.
      await Future<void>.delayed(const Duration(seconds: 2));
      return Screens.s100;
    },
  );
  //endregion
}
