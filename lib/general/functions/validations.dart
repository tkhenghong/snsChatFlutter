isEmpty(Object obj) {
  bool empty = obj.toString() == "" || obj == null;
  return empty;
}