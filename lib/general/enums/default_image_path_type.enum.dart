import 'package:snschat_flutter/general/enums/conversation_group_type.enum.dart';

enum DefaultImagePathType { Personal, Group, UserContact, Broadcast, Profile, ConversationGroupMessage }

extension DefaultImagePathTypeUtil on DefaultImagePathType {
  String get name {
    switch (this) {
      case DefaultImagePathType.Personal:
        return 'Personal';
      case DefaultImagePathType.Group:
        return 'Group';
      case DefaultImagePathType.Broadcast:
        return 'Broadcast';
      case DefaultImagePathType.UserContact:
        return 'UserContact';
      case DefaultImagePathType.Profile:
        return 'Profile';
      case DefaultImagePathType.ConversationGroupMessage:
        return 'ConversationGroupMessage';
      default:
        return null;
    }
  }

  String get path {
    switch (this) {
      case DefaultImagePathType.Personal:
      case DefaultImagePathType.UserContact:
        return 'lib/ui/icons/single_conversation.png';
      case DefaultImagePathType.Group:
        return 'lib/ui/icons/group_conversation.png';
      case DefaultImagePathType.Broadcast:
        return 'lib/ui/icons/broadcast_conversation.png';
      case DefaultImagePathType.Profile:
        return 'lib/ui/icons/default_user_icon.png';
      case DefaultImagePathType.ConversationGroupMessage:
        return 'lib/ui/icons/conversation_group_message.png';
      default:
        return null;
    }
  }

  static DefaultImagePathType getByName(String name) {
    switch (name) {
      case 'Personal':
        return DefaultImagePathType.Personal;
      case 'Group':
        return DefaultImagePathType.Group;
      case 'Broadcast':
        return DefaultImagePathType.Broadcast;
      case 'UserContact':
        return DefaultImagePathType.UserContact;
      case 'Profile':
        return DefaultImagePathType.Profile;
      case 'ConversationGroupMessage':
        return DefaultImagePathType.ConversationGroupMessage;
      default:
        return null;
    }
  }

  static DefaultImagePathType getByConversationGroupType(ConversationGroupType conversationGroupType) {
    switch (conversationGroupType) {
      case ConversationGroupType.Personal:
        return DefaultImagePathType.Personal;
      case ConversationGroupType.Group:
        return DefaultImagePathType.Group;
      case ConversationGroupType.Broadcast:
        return DefaultImagePathType.Broadcast;
      default:
        return null;
    }
  }
}
