import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
                Text(
                  'Item: ${qualityControl.selectedItem.itemId.toString()}',
                  style: TextStyle(fontSize: 16.0),
                ),
                Text(
                  'Description: ${qualityControl.selectedItem.description}',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(
                  height: 8.0,
                ),
                Row(
                  children: [
                    Flexible(
                      flex: 2,
                      fit: FlexFit.tight,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size.fromHeight(64),
                            primary: Colors.green),
                        child: Icon(Icons.check_circle),
                        onPressed: controller.onQualityOkPressed,
                      ),
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size.fromHeight(64),
                            primary: Colors.red),
                        child: Icon(Icons.cancel),
                        onPressed: controller.onQualityNotOkPressed,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
