import 'package:flutter/widgets.dart';
import 'package:flutter_app_navigator2_test/classes/page_stack.dart';
import 'package:flutter_app_navigator2_test/pages/s020_main_menu/s020_main_menu_page.dart';

class S010State extends ChangeNotifier {
  S010State(this.pageStack);

  final PageStack pageStack;
  void doContinue() {
    pageStack.add(S020MainMenuPage.page);
  }
}
