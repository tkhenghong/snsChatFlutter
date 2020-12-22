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
    message: json['message'] == null
        ? null
        : ChatMessage.fromJson(json['message'] as Map<String, dynamic>),
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
      'message': instance.message,
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
  WebSocketEvent.JoinedConversationGroup: 'JoinedConversationGroup',
  WebSocketEvent.LeftConversationGroup: 'LeftConversationGroup',
  WebSocketEvent.UploadedGroupPhoto: 'UploadedGroupPhoto',
  WebSocketEvent.ChangedGroupPhoto: 'ChangedGroupPhoto',
  WebSocketEvent.DeletedGroupPhoto: 'DeletedGroupPhoto',
  WebSocketEvent.ChangedGroupDescription: 'ChangedGroupDescription',
  WebSocketEvent.PromoteGroupAdmin: 'PromoteGroupAdmin',
  WebSocketEvent.DemoteGroupAdmin: 'DemoteGroupAdmin',
  WebSocketEvent.AddGroupMember: 'AddGroupMember',
  WebSocketEvent.RemoveGroupMember: 'RemoveGroupMember',
  WebSocketEvent.ChangedPhoneNumber: 'ChangedPhoneNumber',
  WebSocketEvent.AddedChatMessage: 'AddedChatMessage',
  WebSocketEvent.UpdatedChatMessage: 'UpdatedChatMessage',
  WebSocketEvent.UpdatedChatMessageMultimedia: 'UpdatedChatMessageMultimedia',
  WebSocketEvent.DeletedChatMessage: 'DeletedChatMessage',
  WebSocketEvent.DeletedChatMessageMultimedia: 'DeletedChatMessageMultimedia',
  WebSocketEvent.UpdatedUnreadMessage: 'UpdatedUnreadMessage',
  WebSocketEvent.DeletedUnreadMessage: 'DeletedUnreadMessage',
  WebSocketEvent.UpdatedUser: 'UpdatedUser',
  WebSocketEvent.UpdatedSettings: 'UpdatedSettings',
  WebSocketEvent.ExistingContactJoined: 'ExistingContactJoined',
};

// **************************************************************************
// DataGenerator
// **************************************************************************

abstract class _$WebSocketMessageLombok {
  /// Field
  WebSocketEvent webSocketEvent;
  ConversationGroup conversationGroup;
  ChatMessage message;
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

  void setMessage(ChatMessage message) {
    this.message = message;
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

  ChatMessage getMessage() {
    return message;
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
