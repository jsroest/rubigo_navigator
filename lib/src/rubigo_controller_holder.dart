/// A minimalistic service locator for Objects. Although it does
/// what it should, this class is only here to limit external dependencies in
/// this package and samples.
class RubigoControllerHolder {
  final _controllerCache = <Object>[];

  /// Returns the controller from the cache.
  /// If not found, it creates a new controller with the provided function.
  Object get<SEARCH extends Object>([
    SEARCH Function()? function,
  ]) {
    final existingController =
        _controllerCache._firstWhereOrNull((e) => e is SEARCH);
    if (existingController != null) {
      return existingController;
    }
    final newController = function!.call();
    _controllerCache.add(newController);
    return newController;
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
