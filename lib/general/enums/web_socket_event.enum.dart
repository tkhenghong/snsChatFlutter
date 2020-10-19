enum WebSocketEvent {
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
  ExistingContactJoined
}

extension WebSocketEventUtil on WebSocketEvent {
  String get name {
    switch (this) {
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
      case WebSocketEvent.ExistingContactJoined:
        return 'EXISTING_CONTACT_JOINED';
      default:
        return null;
    }
  }

  static WebSocketEvent getByName(String name) {
    switch (name) {
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
      case 'EXISTING_CONTACT_JOINED':
        return WebSocketEvent.ExistingContactJoined;
      default:
        return null;
    }
  }
}
