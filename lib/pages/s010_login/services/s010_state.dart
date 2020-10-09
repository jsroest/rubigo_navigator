import 'package:flutter/widgets.dart';
import 'package:flutter_rubigo_navigator/classes/page_stack.dart';
import 'package:flutter_rubigo_navigator/pages/s020_main_menu/s020_main_menu_page.dart';

class S010State extends ChangeNotifier {
  S010State(this.pageStack);

  final PageStack pageStack;
  void doContinue() {
    pageStack.add(S020MainMenuPage.page);
  }
}
