/// A minimalistic service locator for Objects. Although it does
/// what it should, this class is only here to limit external dependencies in
/// this package and samples.
class RubigoHolder {
  final _controllerCache = <Object>[];

  /// Use this function to get an [Object] from the cache, or create it if it
  /// does not exist yet. Be aware that this function returns an [Object].
  /// If you want it to return the specific type, use the get function. For
  /// reasons beyond my knowledge, if you change this function to return SEARCH
  /// it infers Object as the type for SEARCH, and that will match always the
  /// first object in the cache.
  Object getOrCreate<SEARCH extends Object>(SEARCH Function() create) {
    final existingController =
        _controllerCache._firstWhereOrNull((e) => e is SEARCH);
    if (existingController != null) {
      return existingController as SEARCH;
    }
    final newInstance = create();
    add(newInstance);
    return newInstance;
  }

  /// Returns an object from the holder.
  SEARCH get<SEARCH extends Object>() {
    final existingController =
        _controllerCache._firstWhereOrNull((e) => e is SEARCH);
    if (existingController != null) {
      return existingController as SEARCH;
    }
    throw UnsupportedError(
      'Type $SEARCH not found. Did you forget to register it?',
    );
  }

  /// Add an object to the holder.
  void add<OBJECT extends Object>(OBJECT object) {
    final existingController =
        _controllerCache._firstWhereOrNull((e) => e is OBJECT);
    if (existingController != null) {
      throw UnsupportedError('You can not register values more than once');
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
