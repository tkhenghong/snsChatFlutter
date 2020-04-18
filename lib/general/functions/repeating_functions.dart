import 'dart:math';

import '../index.dart';

int generateNewId() {
  var random = new Random();
  // Formula: random.nextInt((max - min) + 1) + min;
  int newId = random.nextInt((999999999 - 100000000) + 1) + 100000000;
  return newId;
}

DefaultImagePathType convertConversationGroupTypeToDefaultImagePathType(
    ConversationGroupType conversationGroupType) {
  switch (conversationGroupType) {
    case ConversationGroupType.Personal:
      return DefaultImagePathType.Personal;
      break;
    case ConversationGroupType.Group:
      return DefaultImagePathType.Group;
    case ConversationGroupType.Broadcast:
      return DefaultImagePathType.Broadcast;
    default:
      return DefaultImagePathType.Personal;
  }
}