import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_rubigo_navigator/pages/page_enum.dart';
import 'package:flutter_rubigo_navigator/pages/s200_quality_control/s220_all_rows_done/s220_all_rows_done_controller.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';

class S220AllRowsDonePage extends RubigoPage<Pages, S220AllRowsDoneController> {
  S220AllRowsDonePage(
      ChangeNotifierProvider<S220AllRowsDoneController> controllerProvider)
      : super(controllerProvider);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ready'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.thumb_up,
              size: 64.0,
              color: Colors.green,
            ),
            Text(
              'All checks are done.',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
            ),
          ],
        ),
      ),
    );
  }
}
