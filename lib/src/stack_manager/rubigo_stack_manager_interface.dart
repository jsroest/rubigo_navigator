import 'package:flutter/widgets.dart';

abstract class RubigoStackManagerInterface<SCREEN_ID extends Enum>
    with ChangeNotifier {
  List<Page<void>> get pages;

  Future<void> pop();

  Future<void> popTo(SCREEN_ID screenId);

  Future<void> push(SCREEN_ID screenId);

  Future<void> onDidRemovePage(Page<Object?> page);

  Future<bool> onPopPage(Route<dynamic> route, dynamic result);

  void remove(SCREEN_ID screenId);
}
