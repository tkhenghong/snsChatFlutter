
import 'package:json_annotation/json_annotation.dart';
import 'package:lombok/lombok.dart';
import 'package:snschat_flutter/objects/models/index.dart';

@data
@JsonSerializable()
class GetUserOwnUserContactsRequest {
  @JsonKey(name: 'searchTerm')
  String searchTerm;

  @JsonKey(name: 'pageable')
  Pageable pageable;

  GetUserOwnUserContactsRequest({this.searchTerm, this.pageable});

  factory GetUserOwnUserContactsRequest.fromJson(Map<String, dynamic> json) => _$GetUserOwnUserContactsRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GetUserOwnUserContactsRequestToJson(this);
}