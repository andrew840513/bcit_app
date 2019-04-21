typedef TGroup GroupFunction<TElement, TGroup>(TElement element);

class Grouper<TElement, TGroup> {
  final Map<TGroup, List<TElement>> _groupedList = {};

  Map<dynamic,dynamic> groupMap(List<TElement> collection, GroupFunction<TElement, TGroup> groupBy) {
    if (collection == null) throw ArgumentError("Collection can not be null");
    if (groupBy == null) throw ArgumentError("GroupBy function can not be null");

    collection.forEach((element) {
      var key = groupBy(element);
      if (!_groupedList.containsKey(key)) {
        _groupedList[key] = List<TElement>();
      }
      _groupedList[key].add(element);
    });
    return _groupedList;
  }
}