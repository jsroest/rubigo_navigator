import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:flutter_rubigo_navigator/pages/page_enum.dart';
import 'package:flutter_rubigo_navigator/pages/s020_quality_control/s040_all_rows_done/s040_controller.dart';
import 'package:rubigo_navigator/rubigo.dart';

class S040AllRowsDonePage extends RubigoPage<Pages, S040Controller> {
  S040AllRowsDonePage(ChangeNotifierProvider<S040Controller> controllerProvider)
      : super(controllerProvider);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quality control -Ready'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text('All checks are done'),
          ),
          TextButton(
              onPressed: context.read(controllerProvider).onOkPressed,
              child: Text('OK'))
        ],
      ),
    );
  }
}
