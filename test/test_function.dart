mapToList() {
  const map = {'a' : {'a1' : 1, 'a2' : 2}, 'b' : {'a1' : 3, 'a2' : 4}};
  List list = [];
  map.forEach((key, value) => list.add(value));
  // Iterable<MapEntry<String, Map>> a = map.entries;
}