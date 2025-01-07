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

class RubigoControllerHolder<SCREEN_ID extends Enum> {
  final controllerCache = <RubigoController<SCREEN_ID>>[];

  RubigoController<SCREEN_ID> get<T extends RubigoController<SCREEN_ID>>([
    T Function()? function,
  ]) {
    var controller = controllerCache._firstWhereOrNull((e) => e is T);
    if (controller != null) {
      return controller;
    }
    controller = function!.call();
    controllerCache.add(controller);
    return controller;
  }
}
