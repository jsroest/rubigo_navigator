import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_rubigo_navigator/pages/page_enum.dart';
import 'package:flutter_rubigo_navigator/pages/s200_quality_control/s230_all_rows_done/s230_all_rows_done_controller.dart';
import 'package:rubigo_navigator/rubigo.dart';

class S230AllRowsDonePage extends RubigoPage<Pages, S230AllRowsDoneController> {
  S230AllRowsDonePage(
      ChangeNotifierProvider<S230AllRowsDoneController> controllerProvider)
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
