import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_rubigo_navigator/pages/pages.dart';
import 'package:flutter_rubigo_navigator/pages/s200_quality_control/s230_no_rows_found/s230_no_rows_found_controller.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';

class S230NoRowsFoundPage extends RubigoPage<Pages, S230NoRowsFoundController> {
  S230NoRowsFoundPage(
      ChangeNotifierProvider<S230NoRowsFoundController> controllerProvider)
      : super(controllerProvider);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Info'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.report_problem,
              size: 64.0,
              color: Colors.red,
            ),
            Text(
              'No items to check',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
            ),
          ],
        ),
      ),
    );
  }
}
