// @dart=2.9

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_rubigo_navigator/pages/page_enum.dart';
import 'package:flutter_rubigo_navigator/pages/s200_quality_control/quality_control.dart';
import 'package:flutter_rubigo_navigator/pages/s200_quality_control/s200_select_item/s200_select_item_controller.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';

class S200SelectItemPage extends RubigoPage<Pages, S200SelectItemController> {
  S200SelectItemPage(
      ChangeNotifierProvider<S200SelectItemController> controllerProvider)
      : super(controllerProvider);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select item'),
        automaticallyImplyLeading: false,
      ),
      body: Consumer(
        builder: (context, watch, _) {
          var controller = context.read(controllerProvider);
          var items = watch(qualityControlProvider).items;
          return ListView.separated(
            separatorBuilder: (context, index) => Divider(),
            padding: EdgeInsets.all(16.0),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () => controller.onItemTap(index),
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
                          items[index].itemId.toString(),
                          style: TextStyle(
                            fontSize: 24.0,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          items[index].description,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
