abstract class RubigoNavigatorInterface<T extends Enum> {
  Future<void> push(T page);
  Future<void> pop();
  Future<void> popTo(T page);
  Future<void> remove(T page);
  Future<void> replaceStack(List<T> pages);
}
