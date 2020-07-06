
import 'package:json_annotation/json_annotation.dart';
import 'package:lombok/lombok.dart';

part 'OTPResponse.g.dart';

@data
@JsonSerializable()
class OTPResponse {
  @JsonKey(name: 'otpExpirationDateTime')
  DateTime otpExpirationDateTime;


  OTPResponse({this.otpExpirationDateTime});

  factory OTPResponse.fromJson(Map<String, dynamic> json) => _$OTPResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OTPResponseToJson(this);
}
