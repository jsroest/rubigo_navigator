import 'package:rubigo_navigator/src/rubigo_controller.dart';

extension _IterableExtension<T> on Iterable<T> {
  /// The first element satisfying [test], or `null` if there are none.
  T? _firstWhereOrNull(bool Function(T element) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}

class RubigoControllerHolder<RUBIGO_CONTROLLER extends RubigoController> {
  final controllerCache = <RUBIGO_CONTROLLER>[];

  RUBIGO_CONTROLLER get<SEARCH extends RUBIGO_CONTROLLER>([
    SEARCH Function()? function,
  ]) {
    var controller = controllerCache._firstWhereOrNull((e) => e is SEARCH);
    if (controller != null) {
      return controller;
    }
    controller = function!.call();
    controllerCache.add(controller);
    return controller;
  }
}
