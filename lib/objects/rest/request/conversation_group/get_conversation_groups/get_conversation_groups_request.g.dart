// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_conversation_groups_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetConversationGroupsRequest _$GetConversationGroupsRequestFromJson(
    Map<String, dynamic> json) {
  return GetConversationGroupsRequest(
    conversationGroupName: json['conversationGroupName'] as String,
    pageable: json['pageable'] == null
        ? null
        : Pageable.fromJson(json['pageable'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$GetConversationGroupsRequestToJson(
        GetConversationGroupsRequest instance) =>
    <String, dynamic>{
      'conversationGroupName': instance.conversationGroupName,
      'pageable': instance.pageable,
    };

// **************************************************************************
// DataGenerator
// **************************************************************************

abstract class _$GetConversationGroupsRequestLombok {
  /// Field
  String conversationGroupName;
  Pageable pageable;

  /// Setter

  void setConversationGroupName(String conversationGroupName) {
    this.conversationGroupName = conversationGroupName;
  }

  void setPageable(Pageable pageable) {
    this.pageable = pageable;
  }

  /// Getter
  String getConversationGroupName() {
    return conversationGroupName;
  }

  Pageable getPageable() {
    return pageable;
  }
}
