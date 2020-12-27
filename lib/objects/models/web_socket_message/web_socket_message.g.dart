// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'web_socket_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WebSocketMessage _$WebSocketMessageFromJson(Map<String, dynamic> json) {
  return WebSocketMessage(
    webSocketEvent:
        _$enumDecodeNullable(_$WebSocketEventEnumMap, json['webSocketEvent']),
    conversationGroup: json['conversationGroup'] == null
        ? null
        : ConversationGroup.fromJson(
            json['conversationGroup'] as Map<String, dynamic>),
    chatMessage: json['chatMessage'] == null
        ? null
        : ChatMessage.fromJson(json['chatMessage'] as Map<String, dynamic>),
    multimedia: json['multimedia'] == null
        ? null
        : Multimedia.fromJson(json['multimedia'] as Map<String, dynamic>),
    settings: json['settings'] == null
        ? null
        : Settings.fromJson(json['settings'] as Map<String, dynamic>),
    unreadMessage: json['unreadMessage'] == null
        ? null
        : UnreadMessage.fromJson(json['unreadMessage'] as Map<String, dynamic>),
    user: json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>),
    userContact: json['userContact'] == null
        ? null
        : UserContact.fromJson(json['userContact'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$WebSocketMessageToJson(WebSocketMessage instance) =>
    <String, dynamic>{
      'webSocketEvent': _$WebSocketEventEnumMap[instance.webSocketEvent],
      'conversationGroup': instance.conversationGroup,
      'chatMessage': instance.chatMessage,
      'multimedia': instance.multimedia,
      'settings': instance.settings,
      'unreadMessage': instance.unreadMessage,
      'user': instance.user,
      'userContact': instance.userContact,
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$WebSocketEventEnumMap = {
  WebSocketEvent.NEW_CONVERSATION_GROUP: 'NEW_CONVERSATION_GROUP',
  WebSocketEvent.JOINED_CONVERSATION_GROUP: 'JOINED_CONVERSATION_GROUP',
  WebSocketEvent.LEFT_CONVERSATION_GROUP: 'LEFT_CONVERSATION_GROUP',
  WebSocketEvent.UPLOADED_GROUP_PHOTO: 'UPLOADED_GROUP_PHOTO',
  WebSocketEvent.CHANGED_GROUP_PHOTO: 'CHANGED_GROUP_PHOTO',
  WebSocketEvent.DELETED_GROUP_PHOTO: 'DELETED_GROUP_PHOTO',
  WebSocketEvent.CHANGED_GROUP_NAME: 'CHANGED_GROUP_NAME',
  WebSocketEvent.ChangedGroupDescription: 'ChangedGroupDescription',
  WebSocketEvent.PROMOTE_GROUP_ADMIN: 'PROMOTE_GROUP_ADMIN',
  WebSocketEvent.DEMOTE_GROUP_ADMIN: 'DEMOTE_GROUP_ADMIN',
  WebSocketEvent.ADD_GROUP_MEMBER: 'ADD_GROUP_MEMBER',
  WebSocketEvent.REMOVE_GROUP_MEMBER: 'REMOVE_GROUP_MEMBER',
  WebSocketEvent.CHANGED_PHONE_NUMBER: 'CHANGED_PHONE_NUMBER',
  WebSocketEvent.ADDED_CHAT_MESSAGE: 'ADDED_CHAT_MESSAGE',
  WebSocketEvent.UPDATED_CHAT_MESSAGE: 'UPDATED_CHAT_MESSAGE',
  WebSocketEvent.UPLOADED_CHAT_MESSAGE_MULTIMEDIA:
      'UPLOADED_CHAT_MESSAGE_MULTIMEDIA',
  WebSocketEvent.DELETED_CHAT_MESSAGE: 'DELETED_CHAT_MESSAGE',
  WebSocketEvent.DELETED_CHAT_MESSAGE_MULTIMEDIA:
      'DELETED_CHAT_MESSAGE_MULTIMEDIA',
  WebSocketEvent.NEW_UNREAD_MESSAGE: 'NEW_UNREAD_MESSAGE',
  WebSocketEvent.UPDATED_UNREAD_MESSAGE: 'UPDATED_UNREAD_MESSAGE',
  WebSocketEvent.DELETED_UNREAD_MESSAGE: 'DELETED_UNREAD_MESSAGE',
  WebSocketEvent.UPDATED_USER: 'UPDATED_USER',
  WebSocketEvent.UPDATED_SETTINGS: 'UPDATED_SETTINGS',
  WebSocketEvent.EXISTING_CONTACT_JOINED: 'EXISTING_CONTACT_JOINED',
};

// **************************************************************************
// DataGenerator
// **************************************************************************

abstract class _$WebSocketMessageLombok {
  /// Field
  WebSocketEvent webSocketEvent;
  ConversationGroup conversationGroup;
  ChatMessage chatMessage;
  Multimedia multimedia;
  Settings settings;
  UnreadMessage unreadMessage;
  User user;
  UserContact userContact;

  /// Setter

  void setWebSocketEvent(WebSocketEvent webSocketEvent) {
    this.webSocketEvent = webSocketEvent;
  }

  void setConversationGroup(ConversationGroup conversationGroup) {
    this.conversationGroup = conversationGroup;
  }

  void setChatMessage(ChatMessage chatMessage) {
    this.chatMessage = chatMessage;
  }

  void setMultimedia(Multimedia multimedia) {
    this.multimedia = multimedia;
  }

  void setSettings(Settings settings) {
    this.settings = settings;
  }

  void setUnreadMessage(UnreadMessage unreadMessage) {
    this.unreadMessage = unreadMessage;
  }

  void setUser(User user) {
    this.user = user;
  }

  void setUserContact(UserContact userContact) {
    this.userContact = userContact;
  }

  /// Getter
  WebSocketEvent getWebSocketEvent() {
    return webSocketEvent;
  }

  ConversationGroup getConversationGroup() {
    return conversationGroup;
  }

  ChatMessage getChatMessage() {
    return chatMessage;
  }

  Multimedia getMultimedia() {
    return multimedia;
  }

  Settings getSettings() {
    return settings;
  }

  UnreadMessage getUnreadMessage() {
    return unreadMessage;
  }

  User getUser() {
    return user;
  }

  UserContact getUserContact() {
    return userContact;
  }
}
