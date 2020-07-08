import 'package:json_annotation/json_annotation.dart';
import 'package:lombok/lombok.dart';

part 'MobileNoUserAuthenticationRequest.g.dart';

@data
@JsonSerializable()
class MobileNoUserAuthenticationRequest {
  @JsonKey(name: 'mobileNo')
  String mobileNo;

  MobileNoUserAuthenticationRequest({this.mobileNo});

  factory MobileNoUserAuthenticationRequest.fromJson(Map<String, dynamic> json) => _$MobileNoUserAuthenticationRequestFromJson(json);

  Map<String, dynamic> toJson() => _$MobileNoUserAuthenticationRequestToJson(this);
}
