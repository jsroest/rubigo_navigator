import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:flutter_rubigo_navigator/pages/page_enum.dart';
import 'package:flutter_rubigo_navigator/pages/s020_quality_control/quality_control.dart';
import 'package:flutter_rubigo_navigator/pages/s020_quality_control/s030_perform_check/s030_controller.dart';
import 'package:rubigo_navigator/rubigo.dart';

class S030PerformCheckPage extends RubigoPage<Pages, S030Controller> {
  S030PerformCheckPage(
      ChangeNotifierProvider<S030Controller> controllerProvider)
      : super(controllerProvider);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quality control -Check item'),
      ),
      body: Consumer(
        builder: (context, watch, _) {
          var controller = context.read(controllerProvider);
          var qualityControl = watch(qualityControlProvider);
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Item: ${qualityControl.selectedItem.itemId.toString()}'),
                Text('Description: ${qualityControl.selectedItem.description}'),
                TextButton(
                    onPressed: controller.onQualityOkPressed,
                    child: Text('Quality OK')),
                TextButton(
                    onPressed: controller.onQualityNotOkPressed,
                    child: Text('Quality not OK'))
              ],
            ),
          );
        },
      ),
    );
  }
}
