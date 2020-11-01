import 'package:json_annotation/json_annotation.dart';
import 'package:lombok/lombok.dart';
import 'package:snschat_flutter/objects/models/index.dart';

part 'conversation_pageable_response.g.dart';

@data
@JsonSerializable()
class ConversationPageableResponse {
  @JsonKey(name: 'conversationGroupResponses')
  PageInfo conversationGroupResponses;

  @JsonKey(name: 'unreadMessageResponses')
  PageInfo unreadMessageResponses;

  ConversationPageableResponse({this.conversationGroupResponses, this.unreadMessageResponses});

  factory ConversationPageableResponse.fromJson(Map<String, dynamic> json) => _$ConversationPageableResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ConversationPageableResponseToJson(this);
}