import 'package:example/classes/bread_crumbs_notifier.dart';
import 'package:example/classes/screen_stack_notifier.dart';
import 'package:example/extensions/rubigo_screen_extensions.dart';
import 'package:example/screens/screens.dart';
import 'package:get_it/get_it.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';

final getIt = GetIt.instance;

RubigoRouter<Screens> get rubigoRouter => getIt.get<RubigoRouter<Screens>>();

BreadCrumbsNotifier get breadCrumbsNotifier => getIt.get<BreadCrumbsNotifier>();

ScreenStackNotifier get screenStackNotifier => getIt.get<ScreenStackNotifier>();

RubigoBusyService get rubigoBusyService => getIt.get<RubigoBusyService>();

Future<void> setup() async {
  //region RubigoRouter
  await rubigoRouter.init(
    getFirstScreenAsync: () async {
      // This can be used to wire up the application. During this time a
      // Splash widget is show. When the wiring up completes, this function
      // can return the first page to navigate to.
      await Future<void>.delayed(const Duration(seconds: 2));
      return Screens.s100;
    },
    availableScreens: availableScreens,
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
