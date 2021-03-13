import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rubigo_navigator/services/rubigo_busy_service.dart';

final ws01GetQualityControlItemsProvider = Provider<Ws01GetQualityControlItems>(
  (ref) {
    return Ws01GetQualityControlItems(
      ref.read(busyServiceProvider),
    );
  },
);

class Ws01GetQualityControlItems {
  Ws01GetQualityControlItems(this.busyService);

  final BusyService busyService;

  Future<List<QualityControlItem>> get() async {
    await busyService.protect(
      () async {
        await Future<void>.delayed(Duration(seconds: 1));
      },
    );
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