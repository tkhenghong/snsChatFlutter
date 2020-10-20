enum ConversationGroupType { Personal, Group, Broadcast }

extension ConversationGroupTypeUtil on ConversationGroupType {
  String get name {
    switch (this) {
      case ConversationGroupType.Personal:
        return 'Personal';
      case ConversationGroupType.Group:
        return 'Group';
      case ConversationGroupType.Broadcast:
        return 'Broadcast';
      default:
        return null;
    }
  }

  String get defaultImagePath {
    switch (this) {
      case ConversationGroupType.Personal:
        return 'lib/ui/icons/single_conversation.png';
      case ConversationGroupType.Group:
        return 'lib/ui/icons/group_conversation.png';
      case ConversationGroupType.Broadcast:
        return 'lib/ui/icons/broadcast_conversation.png';
      default:
        return null;
    }
  }

  static ConversationGroupType getByName(String name) {
    switch (name) {
      case 'Personal':
        return ConversationGroupType.Personal;
      case 'Group':
        return ConversationGroupType.Group;
      case 'Broadcast':
        return ConversationGroupType.Broadcast;
      default:
        return null;
    }
  }
}
