// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'web_socket_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WebSocketMessage _$WebSocketMessageFromJson(Map<String, dynamic> json) {
  return WebSocketMessage(
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
      'conversationGroup': instance.conversationGroup,
      'message': instance.message,
      'multimedia': instance.multimedia,
      'settings': instance.settings,
      'unreadMessage': instance.unreadMessage,
      'user': instance.user,
      'userContact': instance.userContact,
    };

// **************************************************************************
// DataGenerator
// **************************************************************************

abstract class _$WebSocketMessageLombok {
  /// Field
  ConversationGroup conversationGroup;
  ChatMessage message;
  Multimedia multimedia;
  Settings settings;
  UnreadMessage unreadMessage;
  User user;
  UserContact userContact;

  /// Setter

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
