import 'package:rubigo_navigator/rubigo_navigator.dart';

extension RubigoScreenExtensions on ListOfRubigoScreens {
  String breadCrumbs() => map((e) => e.screenId.name).join('→').toUpperCase();
}
