import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:flutter_rubigo_navigator/pages/page_enum.dart';
import 'package:flutter_rubigo_navigator/pages/{{#snakeCase}}{{page_id}}{{/snakeCase}}_{{#snakeCase}}{{page_name}}{{/snakeCase}}/{{#snakeCase}}{{page_id}}{{/snakeCase}}_controller.dart';
import 'package:rubigo_navigator/rubigo.dart';

class {{#pascalCase}}{{page_id}}{{/pascalCase}}{{#pascalCase}}{{page_name}}{{/pascalCase}}Page extends RubigoPage<Pages, {{#pascalCase}}{{page_id}}{{/pascalCase}}Controller> {
  {{#pascalCase}}{{page_id}}{{/pascalCase}}{{#pascalCase}}{{page_name}}{{/pascalCase}}Page(ChangeNotifierProvider<{{#pascalCase}}{{page_id}}{{/pascalCase}}Controller> controllerProvider)
      : super(controllerProvider);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Title'),
      ),
      body: Container(),
    );
  }
}