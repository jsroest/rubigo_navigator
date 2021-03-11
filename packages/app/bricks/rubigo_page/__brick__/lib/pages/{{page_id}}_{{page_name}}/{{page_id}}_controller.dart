import 'dart:async';

import 'package:flutter_riverpod/all.dart';
import 'package:flutter_rubigo_navigator/pages/page_enum.dart';
import 'package:flutter_rubigo_navigator/pages/{{#snakeCase}}{{page_id}}_{{/snakeCase}}_{{page_name}}/{{#snakeCase}}{{page_id}}_{{/snakeCase}}_{{page_name}}_page.dart';
import 'package:rubigo_navigator/rubigo.dart';

final {{#pascalCase}}{{page_id}}{{/pascalCase}}ControllerProvider = ChangeNotifierProvider<{{#pascalCase}}{{page_id}}{{/pascalCase}}Controller>(
  (ref) {
    return {{#pascalCase}}{{page_id}}{{/pascalCase}}Controller(
      () => {{#pascalCase}}{{page_id}}{{/pascalCase}}{{#pascalCase}}{{page_name}}{{/pascalCase}}Page({{#pascalCase}}{{page_id}}{{/pascalCase}}ControllerProvider),
    );
  },
);

class {{#pascalCase}}{{page_id}}{{/pascalCase}}Controller extends RubigoController<Pages> {
  {{#pascalCase}}{{page_id}}{{/pascalCase}}Controller(RubigoPage<Pages, RubigoController> Function() getRubigoPage)
      : super(getRubigoPage);
}

