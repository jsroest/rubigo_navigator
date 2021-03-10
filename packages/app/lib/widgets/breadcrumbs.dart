import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:flutter_rubigo_navigator/main.dart';
import 'package:flutter_rubigo_navigator/pages/page_enum.dart';

class BreadCrumbs extends StatelessWidget {
  const BreadCrumbs({Key key, this.page}) : super(key: key);
  final Pages page;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, _) {
        var controllers = watch(appNavigatorProvider).stack;
        var pages = controllers.entries.toList();
        if (page != null) {
          var indexOfThisPage = controllers.keys.toList().lastIndexOf(page);
          if (indexOfThisPage != -1 &&
              controllers.length - 1 > indexOfThisPage) {
            //There are pages above this page
            //remove them from this list, because this shows during the transition between pages
            pages.removeRange(indexOfThisPage + 1, pages.length);
          }
        }
        var pageNames =
            pages.map((e) => EnumToString.convertToString(e.key)).toList();

        var breadCrumbs = pageNames.join(' => ');
        return Text(breadCrumbs);
      },
    );
  }
}
