isObjectEmpty(Object obj) {
  bool empty =  obj == null || obj.toString() == "";
  return empty;
}

isStringEmpty(String string) {
  return string == null || string == "";
}

//bool isItemExistsInList(List<Object> objList, Object obj) {
//  objList.forEach((existingObj) {
//    if(existingObj.id == obj.id) {
//      return true;
//    }
//  });
//  return false;
//}