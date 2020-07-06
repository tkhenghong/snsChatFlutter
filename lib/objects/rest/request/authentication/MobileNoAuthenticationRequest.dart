import 'package:json_annotation/json_annotation.dart';
import 'package:lombok/lombok.dart';

part 'MobileNoAuthenticationRequest.g.dart';

@data
@JsonSerializable()
class MobileNoAuthenticationRequest {
  @JsonKey(name: 'mobileNo')
  String mobileNo;

  MobileNoAuthenticationRequest({this.mobileNo});

  factory MobileNoAuthenticationRequest.fromJson(Map<String, dynamic> json) => _$MobileNoAuthenticationRequestFromJson(json);

  Map<String, dynamic> toJson() => _$MobileNoAuthenticationRequestToJson(this);
}
