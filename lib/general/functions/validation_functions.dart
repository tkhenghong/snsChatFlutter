isObjectEmpty(Object obj) {
  bool empty = obj.toString() == "" || obj == null;
  return empty;
}

isStringEmpty(String string) {
  return string == "" || string == null;
}

//bool isItemExistsInList(List<Object> objList, Object obj) {
//  objList.forEach((existingObj) {
//    if(existingObj.id == obj.id) {
//      return true;
//    }
//  });
//  return false;
//}