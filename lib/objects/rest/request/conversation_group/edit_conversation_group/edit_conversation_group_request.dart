
import 'package:json_annotation/json_annotation.dart';
import 'package:lombok/lombok.dart';

part 'edit_conversation_group_request.g.dart';

@data
@JsonSerializable()
class EditConversationGroupRequest {
  @JsonKey(name: 'id')
  String id;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'description')
  String description;


  EditConversationGroupRequest({this.name, this.description});

  factory EditConversationGroupRequest.fromJson(Map<String, dynamic> json) => _$EditConversationGroupRequestFromJson(json);

  Map<String, dynamic> toJson() => _$EditConversationGroupRequestToJson(this);
}