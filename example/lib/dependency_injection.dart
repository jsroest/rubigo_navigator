import 'package:example/classes/bread_crumbs_notifier.dart';
import 'package:example/extensions/rubigo_screen_extensions.dart';
import 'package:example/screens/screens.dart';
import 'package:example/screens/set1/set1_state.dart';
import 'package:get_it/get_it.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';

final getIt = GetIt.instance;

RubigoRouter<Screens> get rubigoRouter => getIt.get<RubigoRouter<Screens>>();

BreadCrumbsNotifier get breadCrumbsNotifier => getIt.get<BreadCrumbsNotifier>();

String get _breadCrumbsString => 'Stack: ${rubigoRouter.screens.breadCrumbs()}';

void setup() {
  getIt.registerSingleton(RubigoRouter<Screens>());
  rubigoRouter.init(
    initialScreenStack: screenStackSet1,
    availableScreens: availableScreens,
  );
  getIt.registerSingleton(BreadCrumbsNotifier(_breadCrumbsString));
  rubigoRouter.addListener(
    () => breadCrumbsNotifier.value = _breadCrumbsString,
  );
}
