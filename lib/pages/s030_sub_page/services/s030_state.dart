import 'package:flutter_rubigo_navigator/classes/page_stack.dart';
import 'package:flutter_rubigo_navigator/pages/s020_main_menu/s020_main_menu_page.dart';

class S030State {
  S030State(this.pageStack);

  final PageStack pageStack;

  void doContinue() {
    pageStack.remove(S020MainMenuPage.page);
  }
}
