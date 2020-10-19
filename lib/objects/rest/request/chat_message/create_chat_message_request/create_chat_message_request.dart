import 'package:json_annotation/json_annotation.dart';
import 'package:lombok/lombok.dart';

part 'create_chat_message_request.g.dart';

@data
@JsonSerializable()
class CreateChatMessageRequest {
  @JsonKey(name: 'conversationId')
  String conversationId;

  @JsonKey(name: 'messageContent')
  String messageContent;

  CreateChatMessageRequest({this.conversationId, this.messageContent});

  factory CreateChatMessageRequest.fromJson(Map<String, dynamic> json) => _$CreateChatMessageRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateChatMessageRequestToJson(this);
}
