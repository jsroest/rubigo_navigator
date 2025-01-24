/// A minimalistic service locator for Objects. Although it does
/// what it should, this class is only here to limit external dependencies in
/// this package and samples.
class RubigoHolder {
  final _controllerCache = <Object>[];

  /// Returns the controller from the cache.
  /// If not found, it creates a new controller with the provided function.
  /// For some reason it is not possible to return a SEARCH, as this will result
  /// in only type Objects to be added to the cache. Therefore, if you need a
  /// specific type as result, use the get function.
  Object getOrCreate<SEARCH extends Object>(
    SEARCH Function() function,
  ) {
    final existingController = get<SEARCH>();
    if (existingController != null) {
      return existingController;
    }
    final newController = function.call();
    _controllerCache.add(newController);
    return newController;
  }

  /// Get a specific type from the cache.
  SEARCH? get<SEARCH extends Object>() {
    final existingController =
        _controllerCache._firstWhereOrNull((e) => e is SEARCH);
    return existingController as SEARCH?;
  }

  /// Adds an object to the cache, if it does not exist, otherwise, replace the
  /// object.
  void add<T extends Object>(T object) {
    final existingController =
        _controllerCache._firstWhereOrNull((e) => e is T);
    if (existingController != null) {
      return;
    }
    final index = _controllerCache.indexWhere((e) => e is T);
    if (index != -1) {
      _controllerCache[index] = object;
      return;
    }
    _controllerCache.add(object);
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
