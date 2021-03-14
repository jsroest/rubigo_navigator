import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_rubigo_navigator/pages/page_enum.dart';
import 'package:flutter_rubigo_navigator/pages/{{#snakeCase}}{{page_id}}_{{page_name}}{{/snakeCase}}/{{#snakeCase}}{{page_id}}_{{page_name}}{{/snakeCase}}_controller.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';

class {{#pascalCase}}{{page_id}}{{/pascalCase}}{{#pascalCase}}{{page_name}}{{/pascalCase}}Page extends RubigoPage<Pages, {{#pascalCase}}{{page_id}}{{/pascalCase}}{{#pascalCase}}{{page_name}}{{/pascalCase}}Controller> {
  {{#pascalCase}}{{page_id}}{{/pascalCase}}{{#pascalCase}}{{page_name}}{{/pascalCase}}Page(ChangeNotifierProvider<{{#pascalCase}}{{page_id}}{{/pascalCase}}{{#pascalCase}}{{page_name}}{{/pascalCase}}Controller> controllerProvider)
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