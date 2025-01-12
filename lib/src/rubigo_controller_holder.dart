import 'package:rubigo_router/rubigo_router.dart';

/// A minimalistic service locator for [RubigoControllerMixin]. Although it does what
/// it should, this class is only here to limit external dependencies.
class RubigoControllerHolder<RUBIGO_CONTROLLER extends RubigoControllerMixin> {
  final _controllerCache = <RUBIGO_CONTROLLER>[];

  /// Returns the controller from the cache.
  /// If not found, it creates a new controller with the provided function.
  RUBIGO_CONTROLLER get<SEARCH extends RUBIGO_CONTROLLER>([
    SEARCH Function()? function,
  ]) {
    var controller = _controllerCache._firstWhereOrNull((e) => e is SEARCH);
    if (controller != null) {
      return controller;
    }
    controller = function!.call();
    _controllerCache.add(controller);
    return controller;
  }
}

extension _IterableExtension<T> on Iterable<T> {
  /// The first element satisfying [test], or `null` if there are none.
  T? _firstWhereOrNull(bool Function(T element) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}
