enum WebSocketEvent {
  // Conversation Group Events
  NEW_CONVERSATION_GROUP,
  JOINED_CONVERSATION_GROUP,
  LEFT_CONVERSATION_GROUP,
  UPLOADED_GROUP_PHOTO,
  CHANGED_GROUP_PHOTO,
  DELETED_GROUP_PHOTO,
  CHANGED_GROUP_NAME,
  ChangedGroupDescription,
  PROMOTE_GROUP_ADMIN,
  DEMOTE_GROUP_ADMIN,
  ADD_GROUP_MEMBER,
  REMOVE_GROUP_MEMBER,
  CHANGED_PHONE_NUMBER,

  // Chat Message Events
  ADDED_CHAT_MESSAGE,
  UPDATED_CHAT_MESSAGE,
  UPLOADED_CHAT_MESSAGE_MULTIMEDIA,
  DELETED_CHAT_MESSAGE,
  DELETED_CHAT_MESSAGE_MULTIMEDIA,

  // Unread Message Events
  NEW_UNREAD_MESSAGE,
  UPDATED_UNREAD_MESSAGE,
  DELETED_UNREAD_MESSAGE,

  // User Events,
  UPDATED_USER,

  // Settings Events
  UPDATED_SETTINGS,

  // User Contact Events
  EXISTING_CONTACT_JOINED
}

extension WebSocketEventUtil on WebSocketEvent {
  String get name {
    switch (this) {
      // Conversation Group Events
      case WebSocketEvent.NEW_CONVERSATION_GROUP:
        return 'NEW_CONVERSATION_GROUP';
      case WebSocketEvent.JOINED_CONVERSATION_GROUP:
        return 'JOINED_CONVERSATION_GROUP';
      case WebSocketEvent.LEFT_CONVERSATION_GROUP:
        return 'LEFT_CONVERSATION_GROUP';
      case WebSocketEvent.UPLOADED_GROUP_PHOTO:
        return 'UPLOADED_GROUP_PHOTO';
      case WebSocketEvent.CHANGED_GROUP_PHOTO:
        return 'CHANGED_GROUP_PHOTO';
      case WebSocketEvent.DELETED_GROUP_PHOTO:
        return 'DELETED_GROUP_PHOTO';
      case WebSocketEvent.CHANGED_GROUP_NAME:
        return 'CHANGED_GROUP_NAME';
      case WebSocketEvent.PROMOTE_GROUP_ADMIN:
        return 'PROMOTE_GROUP_ADMIN';
      case WebSocketEvent.DEMOTE_GROUP_ADMIN:
        return 'DEMOTE_GROUP_ADMIN';
      case WebSocketEvent.ADD_GROUP_MEMBER:
        return 'ADD_GROUP_MEMBER';
      case WebSocketEvent.REMOVE_GROUP_MEMBER:
        return 'REMOVE_GROUP_MEMBER';
      case WebSocketEvent.CHANGED_PHONE_NUMBER:
        return 'CHANGED_PHONE_NUMBER';

      // Chat Message Events
      case WebSocketEvent.ADDED_CHAT_MESSAGE:
        return 'ADDED_CHAT_MESSAGE';
      case WebSocketEvent.UPDATED_CHAT_MESSAGE:
        return 'UPDATED_CHAT_MESSAGE';
      case WebSocketEvent.UPLOADED_CHAT_MESSAGE_MULTIMEDIA:
        return 'UPLOADED_CHAT_MESSAGE_MULTIMEDIA';
      case WebSocketEvent.DELETED_CHAT_MESSAGE:
        return 'DELETED_CHAT_MESSAGE';
      case WebSocketEvent.DELETED_CHAT_MESSAGE_MULTIMEDIA:
        return 'DELETED_CHAT_MESSAGE_MULTIMEDIA';

      // Unread Message Events
      case WebSocketEvent.UPDATED_UNREAD_MESSAGE:
        return 'UPDATED_UNREAD_MESSAGE';
      case WebSocketEvent.NEW_UNREAD_MESSAGE:
        return 'NEW_UNREAD_MESSAGE';
      case WebSocketEvent.DELETED_UNREAD_MESSAGE:
        return 'DELETED_UNREAD_MESSAGE';

      // User Events
      case WebSocketEvent.UPDATED_USER:
        return 'UPDATED_USER';

      // Settings Events
      case WebSocketEvent.UPDATED_SETTINGS:
        return 'UPDATED_SETTINGS';

      // User Contact Events
      case WebSocketEvent.EXISTING_CONTACT_JOINED:
        return 'EXISTING_CONTACT_JOINED';
      default:
        return null;
    }
  }

  static WebSocketEvent getByName(String name) {
    switch (name) {
      // Conversation Group Events
      case 'NEW_CONVERSATION_GROUP':
        return WebSocketEvent.NEW_CONVERSATION_GROUP;
      case 'JOINED_CONVERSATION_GROUP':
        return WebSocketEvent.JOINED_CONVERSATION_GROUP;
      case 'LEFT_CONVERSATION_GROUP':
        return WebSocketEvent.LEFT_CONVERSATION_GROUP;
      case 'UPLOADED_GROUP_PHOTO':
        return WebSocketEvent.UPLOADED_GROUP_PHOTO;
      case 'CHANGED_GROUP_PHOTO':
        return WebSocketEvent.CHANGED_GROUP_PHOTO;
      case 'DELETED_GROUP_PHOTO':
        return WebSocketEvent.DELETED_GROUP_PHOTO;
      case 'CHANGED_GROUP_NAME':
        return WebSocketEvent.CHANGED_GROUP_NAME;
      case 'CHANGED_GROUP_DESCRIPTION':
        return WebSocketEvent.ChangedGroupDescription;
      case 'PROMOTE_GROUP_ADMIN':
        return WebSocketEvent.PROMOTE_GROUP_ADMIN;
      case 'DEMOTE_GROUP_ADMIN':
        return WebSocketEvent.DEMOTE_GROUP_ADMIN;
      case 'ADD_GROUP_MEMBER':
        return WebSocketEvent.ADD_GROUP_MEMBER;
      case 'REMOVE_GROUP_MEMBER':
        return WebSocketEvent.REMOVE_GROUP_MEMBER;
      case 'CHANGED_PHONE_NUMBER':
        return WebSocketEvent.CHANGED_PHONE_NUMBER;

      // Chat Message Events
      case 'ADDED_CHAT_MESSAGE':
        return WebSocketEvent.ADDED_CHAT_MESSAGE;
      case 'UPDATED_CHAT_MESSAGE':
        return WebSocketEvent.UPDATED_CHAT_MESSAGE;
      case 'UPLOADED_CHAT_MESSAGE_MULTIMEDIA':
        return WebSocketEvent.UPLOADED_CHAT_MESSAGE_MULTIMEDIA;
      case 'DELETED_CHAT_MESSAGE':
        return WebSocketEvent.DELETED_CHAT_MESSAGE;
      case 'DELETED_CHAT_MESSAGE_MULTIMEDIA':
        return WebSocketEvent.DELETED_CHAT_MESSAGE_MULTIMEDIA;

      // Unread Message Events
      case 'NEW_UNREAD_MESSAGE':
        return WebSocketEvent.NEW_UNREAD_MESSAGE;
      case 'UPDATED_UNREAD_MESSAGE':
        return WebSocketEvent.UPDATED_UNREAD_MESSAGE;
      case 'DELETED_UNREAD_MESSAGE':
        return WebSocketEvent.DELETED_UNREAD_MESSAGE;

      // User Events
      case 'UPDATED_USER':
        return WebSocketEvent.UPDATED_USER;

      // Settings Events
      case 'UPDATED_SETTINGS':
        return WebSocketEvent.UPDATED_SETTINGS;

      // User Contact Events
      case 'EXISTING_CONTACT_JOINED':
        return WebSocketEvent.EXISTING_CONTACT_JOINED;
      default:
        return null;
    }
  }
}
