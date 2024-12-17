import 'package:flutter/widgets.dart';
import 'package:rubigo_navigator/src/types/rubigo_type_definitions.dart';

abstract class RubigoStackManagerInterface<SCREEN_ID extends Enum>
    with ChangeNotifier {
  //This is the actual screen stack
  List<SCREEN_ID> get screenStack;

  //This is a list of all available screens
  ListOfRubigoScreens<SCREEN_ID> get availableScreens;

  Future<void> pop();

  Future<void> popTo(SCREEN_ID screenId);

  Future<void> push(SCREEN_ID screenId);

  void onDidRemovePage(Page<Object?> page);

  void remove(SCREEN_ID screenId);
}
