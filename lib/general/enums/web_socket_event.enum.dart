enum WebSocketEvent {
  // Conversation Group Events
  NewConversationGroup,
  JoinedConversationGroup,
  LeftConversationGroup,
  UploadedGroupPhoto,
  ChangedGroupPhoto,
  DeletedGroupPhoto,
  ChangedGroupDescription,
  PromoteGroupAdmin,
  DemoteGroupAdmin,
  AddGroupMember,
  RemoveGroupMember,
  ChangedPhoneNumber,

  // Chat Message Events
  AddedChatMessage,
  UpdatedChatMessage,
  UpdatedChatMessageMultimedia,
  DeletedChatMessage,
  DeletedChatMessageMultimedia,

  // Unread Message Events
  NewUnreadMessage,
  UpdatedUnreadMessage,
  DeletedUnreadMessage,

  // User Events,
  UpdatedUser,

  // Settings Events
  UpdatedSettings,

  // User Contact Events
  ExistingContactJoined
}

extension WebSocketEventUtil on WebSocketEvent {
  String get name {
    switch (this) {
      // Conversation Group Events
      case WebSocketEvent.NewConversationGroup:
        return 'NEW_CONVERSATION_GROUP';
      case WebSocketEvent.JoinedConversationGroup:
        return 'JOINED_CONVERSATION_GROUP';
      case WebSocketEvent.LeftConversationGroup:
        return 'LEFT_CONVERSATION_GROUP';
      case WebSocketEvent.UploadedGroupPhoto:
        return 'UPLOADED_GROUP_PHOTO';
      case WebSocketEvent.ChangedGroupPhoto:
        return 'CHANGED_GROUP_PHOTO';
      case WebSocketEvent.DeletedGroupPhoto:
        return 'DELETED_GROUP_PHOTO';
      case WebSocketEvent.ChangedGroupDescription:
        return 'CHANGED_GROUP_DESCRIPTION';
      case WebSocketEvent.PromoteGroupAdmin:
        return 'PROMOTE_GROUP_ADMIN';
      case WebSocketEvent.DemoteGroupAdmin:
        return 'DEMOTE_GROUP_ADMIN';
      case WebSocketEvent.AddGroupMember:
        return 'ADD_GROUP_MEMBER';
      case WebSocketEvent.RemoveGroupMember:
        return 'REMOVE_GROUP_MEMBER';
      case WebSocketEvent.ChangedPhoneNumber:
        return 'CHANGED_PHONE_NUMBER';

      // Chat Message Events
      case WebSocketEvent.AddedChatMessage:
        return 'ADDED_CHAT_MESSAGE';
      case WebSocketEvent.UpdatedChatMessage:
        return 'UPDATED_CHAT_MESSAGE';
      case WebSocketEvent.UpdatedChatMessageMultimedia:
        return 'UPLOADED_CHAT_MESSAGE_MULTIMEDIA';
      case WebSocketEvent.DeletedChatMessage:
        return 'DELETED_CHAT_MESSAGE';
      case WebSocketEvent.DeletedChatMessageMultimedia:
        return 'DELETED_CHAT_MESSAGE_MULTIMEDIA';

      // Unread Message Events
      case WebSocketEvent.UpdatedUnreadMessage:
        return 'UPDATED_UNREAD_MESSAGE';
      case WebSocketEvent.NewUnreadMessage:
        return 'NEW_UNREAD_MESSAGE';
      case WebSocketEvent.DeletedUnreadMessage:
        return 'DELETED_UNREAD_MESSAGE';

      // User Events
      case WebSocketEvent.UpdatedUser:
        return 'UPDATED_USER';

      // Settings Events
      case WebSocketEvent.UpdatedSettings:
        return 'UPDATED_SETTINGS';

      // User Contact Events
      case WebSocketEvent.ExistingContactJoined:
        return 'EXISTING_CONTACT_JOINED';
      default:
        return null;
    }
  }

  static WebSocketEvent getByName(String name) {
    switch (name) {
      // Conversation Group Events
      case 'NEW_CONVERSATION_GROUP':
        return WebSocketEvent.NewConversationGroup;
      case 'JOINED_CONVERSATION_GROUP':
        return WebSocketEvent.JoinedConversationGroup;
      case 'LEFT_CONVERSATION_GROUP':
        return WebSocketEvent.LeftConversationGroup;
      case 'UPLOADED_GROUP_PHOTO':
        return WebSocketEvent.UploadedGroupPhoto;
      case 'CHANGED_GROUP_PHOTO':
        return WebSocketEvent.ChangedGroupPhoto;
      case 'DELETED_GROUP_PHOTO':
        return WebSocketEvent.DeletedGroupPhoto;
      case 'CHANGED_GROUP_DESCRIPTION':
        return WebSocketEvent.ChangedGroupDescription;
      case 'PROMOTE_GROUP_ADMIN':
        return WebSocketEvent.PromoteGroupAdmin;
      case 'DEMOTE_GROUP_ADMIN':
        return WebSocketEvent.DemoteGroupAdmin;
      case 'ADD_GROUP_MEMBER':
        return WebSocketEvent.AddGroupMember;
      case 'REMOVE_GROUP_MEMBER':
        return WebSocketEvent.RemoveGroupMember;
      case 'CHANGED_PHONE_NUMBER':
        return WebSocketEvent.ChangedPhoneNumber;

      // Chat Message Events
      case 'ADDED_CHAT_MESSAGE':
        return WebSocketEvent.AddedChatMessage;
      case 'UPDATED_CHAT_MESSAGE':
        return WebSocketEvent.UpdatedChatMessage;
      case 'UPLOADED_CHAT_MESSAGE_MULTIMEDIA':
        return WebSocketEvent.UpdatedChatMessageMultimedia;
      case 'DELETED_CHAT_MESSAGE':
        return WebSocketEvent.DeletedChatMessage;
      case 'DELETED_CHAT_MESSAGE_MULTIMEDIA':
        return WebSocketEvent.DeletedChatMessageMultimedia;

      // Unread Message Events
      case 'NEW_UNREAD_MESSAGE':
        return WebSocketEvent.NewUnreadMessage;
      case 'UPDATED_UNREAD_MESSAGE':
        return WebSocketEvent.UpdatedUnreadMessage;
      case 'DELETED_UNREAD_MESSAGE':
        return WebSocketEvent.DeletedUnreadMessage;

      // User Events
      case 'UPDATED_USER':
        return WebSocketEvent.UpdatedUser;

      // Settings Events
      case 'UPDATED_SETTINGS':
        return WebSocketEvent.UpdatedSettings;

      // User Contact Events
      case 'EXISTING_CONTACT_JOINED':
        return WebSocketEvent.ExistingContactJoined;
      default:
        return null;
    }
  }
}
