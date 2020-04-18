isObjectEmpty(Object obj) {
  bool empty =  obj == null || obj.toString() == "";
  return empty;
}

isStringEmpty(String string) {
  return string == null || string == "" || string == "null";
}
