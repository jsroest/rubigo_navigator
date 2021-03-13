import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_rubigo_navigator/pages/page_enum.dart';
import 'package:flutter_rubigo_navigator/pages/s020_quality_control/quality_control.dart';
import 'package:flutter_rubigo_navigator/pages/s020_quality_control/s020_select_item/s020_controller.dart';
import 'package:rubigo_navigator/rubigo.dart';

class S020SelectItemPage extends RubigoPage<Pages, S020Controller> {
  S020SelectItemPage(ChangeNotifierProvider<S020Controller> controllerProvider)
      : super(controllerProvider);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quality control -select item'),
        leading: Container(),
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
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Item: ',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          items[index].itemId.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          items[index].description,
                          style: TextStyle(fontSize: 20.0),
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
