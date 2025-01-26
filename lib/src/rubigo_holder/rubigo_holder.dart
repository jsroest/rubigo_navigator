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
  Object getOrCreate<T extends Object>(
    T Function() function,
  ) {
    final index = _controllerCache.indexWhere((e) => e is T);
    if (index != -1) {
      return _controllerCache[index];
    }
    final newController = function.call();
    _controllerCache.add(newController);
    return newController;
  }

  /// Get a specific type from the cache.
  T get<T extends Object>() {
    return _controllerCache.firstWhere((e) => e is T) as T;
  }

  /// Adds an object to the cache, if it does not exist, otherwise, replace the
  /// object.
  void add<T extends Object>(T object) {
    final index = _controllerCache.indexWhere((e) => e is T);
    if (index != -1) {
      _controllerCache[index] = object;
      return;
    }
    _controllerCache.add(object);
  }
}
