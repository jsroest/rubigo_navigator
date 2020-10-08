import 'package:flutter/material.dart';
import 'package:flutter_app_navigator2_test/classes/page_stack.dart';
import 'package:provider/provider.dart';

class BreadCrumbs extends StatelessWidget {
  const BreadCrumbs({Key key, this.page}) : super(key: key);
  final Page page;

  @override
  Widget build(BuildContext context) {
    var pages = List<Page>.from(Provider.of<PageStack>(context).pages);
    if (page != null) {
      var indexOfThisPage = pages.lastIndexWhere((element) => element == page);
      if (pages.length - 1 > indexOfThisPage) {
        //There are page above this page
        //remove them from this list, because this shows during the transition between pages
        pages.removeRange(indexOfThisPage + 1, pages.length);
      }
    }
    var pageNames = pages.map((e) => e.name).toList();

    var breadCrumbs = pageNames.join('=>');
    return Text(breadCrumbs);
  }
}
