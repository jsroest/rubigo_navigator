import 'package:flutter_riverpod/all.dart';

final ws01GetQualityControlItemsProvider = Provider<Ws01GetQualityControlItems>(
  (ref) {
    return Ws01GetQualityControlItems();
  },
);

class Ws01GetQualityControlItems {
  Future<List<QualityControlItem>> get() async {
    await Future<void>.delayed(Duration(seconds: 1));
    //return <QualityControlItem>[];
    return <QualityControlItem>[
      QualityControlItem(1, 'Assembly'),
      QualityControlItem(2, 'Steel case'),
      QualityControlItem(3, 'Power cord'),
    ];
  }
}

class QualityControlItem {
  QualityControlItem(this.itemId, this.description);

  final int itemId;
  final String description;
}
