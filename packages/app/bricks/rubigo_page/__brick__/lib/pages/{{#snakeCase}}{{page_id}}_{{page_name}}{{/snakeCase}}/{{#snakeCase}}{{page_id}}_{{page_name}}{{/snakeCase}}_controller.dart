import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_rubigo_navigator/pages/page_enum.dart';
import 'package:flutter_rubigo_navigator/pages/{{#snakeCase}}{{page_id}}_{{page_name}}{{/snakeCase}}/{{#snakeCase}}{{page_id}}_{{page_name}}{{/snakeCase}}_page.dart';
import 'package:rubigo_navigator/rubigo.dart';

final {{#camelCase}}{{page_id}}{{/camelCase}}{{#pascalCase}}{{page_name}}{{/pascalCase}}ControllerProvider = ChangeNotifierProvider<{{#pascalCase}}{{page_id}}{{/pascalCase}}{{#pascalCase}}{{page_name}}{{/pascalCase}}Controller>(
  (ref) {
    return {{#pascalCase}}{{page_id}}{{/pascalCase}}{{#pascalCase}}{{page_name}}{{/pascalCase}}Controller(
      () => {{#pascalCase}}{{page_id}}{{/pascalCase}}{{#pascalCase}}{{page_name}}{{/pascalCase}}Page({{#camelCase}}{{page_id}}{{/camelCase}}{{#pascalCase}}{{page_name}}{{/pascalCase}}ControllerProvider),
    );
  },
);

class {{#pascalCase}}{{page_id}}{{/pascalCase}}{{#pascalCase}}{{page_name}}{{/pascalCase}}Controller extends RubigoController<Pages> {
  {{#pascalCase}}{{page_id}}{{/pascalCase}}{{#pascalCase}}{{page_name}}{{/pascalCase}}Controller(RubigoPage<Pages, RubigoController> Function() getRubigoPage)
      : super(getRubigoPage);
}

