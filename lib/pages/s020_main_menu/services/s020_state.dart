import 'package:flutter_app_navigator2_test/classes/page_stack.dart';
import 'package:flutter_app_navigator2_test/pages/s030_sub_page/s030_sub_page.dart';

class S020State {
  S020State(this.pageStack);

  final PageStack pageStack;

  void doContinue() {
    pageStack.add(S030SubPage.page);
  }
}
