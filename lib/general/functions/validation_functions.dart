isObjectEmpty(Object obj) {
  return obj == null;
}

isStringEmpty(String string) {
  return string == null || string == "" || string.trim().isEmpty;
}