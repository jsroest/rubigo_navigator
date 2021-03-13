import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_rubigo_navigator/pages/page_enum.dart';
import 'package:flutter_rubigo_navigator/pages/s200_quality_control/quality_control.dart';
import 'package:flutter_rubigo_navigator/pages/s200_quality_control/s220_perform_check/s220_perform_check_controller.dart';
import 'package:rubigo_navigator/rubigo.dart';

class S220PerformCheckPage
    extends RubigoPage<Pages, S220PerformCheckController> {
  S220PerformCheckPage(
      ChangeNotifierProvider<S220PerformCheckController> controllerProvider)
      : super(controllerProvider);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Check item'),
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
                ListTile(
                  leading: Icon(
                    Icons.fact_check,
                    color: Colors.green,
                    size: 48.0,
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Item: ',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 24.0,
                            ),
                          ),
                          Text(
                            qualityControl.selectedItem.itemId.toString(),
                            style: TextStyle(
                              fontSize: 24.0,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            qualityControl.selectedItem.description,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 32.0,
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
                        child: Icon(
                          Icons.check_circle,
                          size: 48.0,
                        ),
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
                        child: Icon(
                          Icons.cancel,
                          size: 48.0,
                        ),
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
