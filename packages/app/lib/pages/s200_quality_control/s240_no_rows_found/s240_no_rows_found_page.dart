import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_rubigo_navigator/pages/page_enum.dart';
import 'package:flutter_rubigo_navigator/pages/s200_quality_control/s240_no_rows_found/s240_no_rows_found_controller.dart';
import 'package:rubigo_navigator/rubigo.dart';

class S240NoRowsFoundPage extends RubigoPage<Pages, S240NoRowsFoundController> {
  S240NoRowsFoundPage(
      ChangeNotifierProvider<S240NoRowsFoundController> controllerProvider)
      : super(controllerProvider);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quality control -Warning'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text('No quality check rows found'),
          ),
          TextButton(
              onPressed: context.read(controllerProvider).onOkPressed,
              child: Text('OK'))
        ],
      ),
    );
  }
}
