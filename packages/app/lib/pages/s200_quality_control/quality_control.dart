import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_rubigo_navigator/services/ws01_get_quality_control_items.dart';

final qualityControlProvider = ChangeNotifierProvider<QualityControl>(
  (ref) {
    return QualityControl();
  },
);

class QualityControl extends ChangeNotifier {
  var _items = <QualityControlItem>[];

  List<QualityControlItem> get items => _items;

  set items(List<QualityControlItem> value) {
    if (_items != value) {
      _items = value;
      notifyListeners();
    }
  }

  void remove(QualityControlItem item) {
    _items.remove(item);
    notifyListeners();
  }

  late QualityControlItem _selectedItem;

  QualityControlItem get selectedItem => _selectedItem;

  set selectedItem(QualityControlItem value) {
    if (_selectedItem != value) {
      _selectedItem = value;
      notifyListeners();
    }
  }
}
