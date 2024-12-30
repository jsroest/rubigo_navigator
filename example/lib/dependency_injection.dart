import 'package:example/classes/bread_crumbs_notifier.dart';
import 'package:example/classes/screen_stack_notifier.dart';
import 'package:example/extensions/rubigo_screen_extensions.dart';
import 'package:example/screens/screens.dart';
import 'package:example/screens/set1/set1_state.dart';
import 'package:get_it/get_it.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';

final getIt = GetIt.instance;

RubigoRouter<Screens> get rubigoRouter => getIt.get<RubigoRouter<Screens>>();

BreadCrumbsNotifier get breadCrumbsNotifier => getIt.get<BreadCrumbsNotifier>();

ScreenStackNotifier get screenStackNotifier => getIt.get<ScreenStackNotifier>();

void setup() {
  //region RubigoRouter
  final rubigoRouter = RubigoRouter<Screens>();
  getIt.registerSingleton(rubigoRouter);
  rubigoRouter.init(
    initialScreenStack: screenStackSet1,
    availableScreens: availableScreens,
    splashScreen: Screens.splashScreen,
    initializeServices: () => Future<void>.delayed(const Duration(seconds: 2)),
  );
  //endregion

  //region BreadCrumbsNotifier
  String breadCrumbsString() => 'Stack: ${rubigoRouter.screens.breadCrumbs()}';
  final breadCrumbsNotifier = BreadCrumbsNotifier(breadCrumbsString());
  getIt.registerSingleton(breadCrumbsNotifier);
  rubigoRouter
      .addListener(() => breadCrumbsNotifier.value = breadCrumbsString());
  //endregion

  //region ScreenStackNotifier
  List<Screens> listOfScreenId() => rubigoRouter.screens.toListOfScreenId();
  final screenStackNotifier = ScreenStackNotifier(listOfScreenId());
  getIt.registerSingleton(screenStackNotifier);
  rubigoRouter.addListener(() => screenStackNotifier.value = listOfScreenId());
  //endregion
}
