import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_rubigo_navigator/pages/page_enum.dart';
import 'package:flutter_rubigo_navigator/pages/s020_quality_control/s050_no_rows_found/s050_controller.dart';
import 'package:rubigo_navigator/rubigo.dart';

class S050NoRowsFoundPage extends RubigoPage<Pages, S050Controller> {
  S050NoRowsFoundPage(ChangeNotifierProvider<S050Controller> controllerProvider)
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
