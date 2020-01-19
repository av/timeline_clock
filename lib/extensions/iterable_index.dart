/// Iterating addons for keeping the current element index
/// where needed
extension IterableIndex<E> on Iterable<E> {
  void forEachIndex(void iterator(E element, int index)) {
    var i = 0;
    this.forEach((item) => iterator(item, i++));
  }

  List<T> mapIndex<T>(T iterator(E element, int index)) {
    var i = 0;
    return this.map<T>((item) => iterator(item, i++)).toList();
  }
}
