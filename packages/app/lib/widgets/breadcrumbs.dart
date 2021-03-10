import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:flutter_rubigo_navigator/main.dart';

class BreadCrumbs extends StatelessWidget {
  const BreadCrumbs({Key key, this.page}) : super(key: key);
  final Page page;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, _) {
        var pages = List<Page>.from(watch(appNavigatorProvider).pages);
        if (page != null) {
          var indexOfThisPage =
              pages.lastIndexWhere((element) => element == page);
          if (pages.length - 1 > indexOfThisPage) {
            //There are page above this page
            //remove them from this list, because this shows during the transition between pages
            pages.removeRange(indexOfThisPage + 1, pages.length);
          }
        }
        var pageNames = pages.map((e) => e.name).toList();

        var breadCrumbs = pageNames.join('=>');
        return Text(breadCrumbs);
      },
    );
  }
}
