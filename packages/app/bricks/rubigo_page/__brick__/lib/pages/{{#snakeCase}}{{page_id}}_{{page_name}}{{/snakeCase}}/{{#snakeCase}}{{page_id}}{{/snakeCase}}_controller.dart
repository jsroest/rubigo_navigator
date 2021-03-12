import 'dart:async';

import 'package:flutter_riverpod/all.dart';
import 'package:flutter_rubigo_navigator/pages/page_enum.dart';
import 'package:flutter_rubigo_navigator/pages/{{#snakeCase}}{{page_id}}__{{page_name}}{{/snakeCase}}/{{#snakeCase}}{{page_id}}_{{page_name}}{{/snakeCase}}_page.dart';
import 'package:rubigo_navigator/rubigo.dart';

final {{#camelCase}}{{page_id}}{{/camelCase}}ControllerProvider = ChangeNotifierProvider<{{#pascalCase}}{{page_id}}{{/pascalCase}}Controller>(
  (ref) {
    return {{#pascalCase}}{{page_id}}{{/pascalCase}}Controller(
      () => {{#pascalCase}}{{page_id}}{{/pascalCase}}{{#pascalCase}}{{page_name}}{{/pascalCase}}Page({{#camelCase}}{{page_id}}{{/camelCase}}ControllerProvider),
    );
  },
);

class {{#pascalCase}}{{page_id}}{{/pascalCase}}Controller extends RubigoController<Pages> {
  {{#pascalCase}}{{page_id}}{{/pascalCase}}Controller(RubigoPage<Pages, RubigoController> Function() getRubigoPage)
      : super(getRubigoPage);
}

