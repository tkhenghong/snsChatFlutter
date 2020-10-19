import 'package:json_annotation/json_annotation.dart';
import 'package:lombok/lombok.dart';
import 'package:snschat_flutter/general/index.dart';
import 'package:snschat_flutter/objects/models/index.dart';

part 'web_socket_message.g.dart';

@data
@JsonSerializable()
class WebSocketMessage {
  @JsonKey(name: 'webSocketEvent')
  WebSocketEvent webSocketEvent;

  @JsonKey(name: 'conversationGroup')
  ConversationGroup conversationGroup;

  @JsonKey(name: 'message')
  ChatMessage message;

  @JsonKey(name: 'multimedia')
  Multimedia multimedia;

  @JsonKey(name: 'settings')
  Settings settings;

  @JsonKey(name: 'unreadMessage')
  UnreadMessage unreadMessage;

  @JsonKey(name: 'user')
  User user;

  @JsonKey(name: 'userContact')
  UserContact userContact;

  WebSocketMessage({this.webSocketEvent, this.conversationGroup, this.message, this.multimedia, this.settings, this.unreadMessage, this.user, this.userContact});

  factory WebSocketMessage.fromJson(Map<String, dynamic> json) => _$WebSocketMessageFromJson(json);

  Map<String, dynamic> toJson() => _$WebSocketMessageToJson(this);
}
