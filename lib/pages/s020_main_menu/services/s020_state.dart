import 'package:flutter_rubigo_navigator/classes/page_stack.dart';
import 'package:flutter_rubigo_navigator/pages/s030_sub_page/s030_sub_page.dart';

class S020State {
  S020State(this.pageStack);

  final PageStack pageStack;

  void doContinue() {
    pageStack.add(S030SubPage.page);
  }
}
