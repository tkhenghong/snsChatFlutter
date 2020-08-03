// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserAuthenticationResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserAuthenticationResponse _$UserAuthenticationResponseFromJson(
    Map<String, dynamic> json) {
  return UserAuthenticationResponse(
    jwt: json['jwt'] as String,
    username: json['username'] as String,
    otpExpirationTime: json['otpExpirationTime'] == null
        ? null
        : DateTime.parse(json['otpExpirationTime'] as String),
  );
}

Map<String, dynamic> _$UserAuthenticationResponseToJson(
        UserAuthenticationResponse instance) =>
    <String, dynamic>{
      'jwt': instance.jwt,
      'username': instance.username,
      'otpExpirationTime': instance.otpExpirationTime?.toIso8601String(),
    };

// **************************************************************************
// DataGenerator
// **************************************************************************

abstract class _$UserAuthenticationResponseLombok {
  /// Field
  String jwt;
  String username;
  DateTime otpExpirationTime;

  /// Setter

  void setJwt(String jwt) {
    this.jwt = jwt;
  }

  void setUsername(String username) {
    this.username = username;
  }

  void setOtpExpirationTime(DateTime otpExpirationTime) {
    this.otpExpirationTime = otpExpirationTime;
  }

  /// Getter
  String getJwt() {
    return jwt;
  }

  String getUsername() {
    return username;
  }

  DateTime getOtpExpirationTime() {
    return otpExpirationTime;
  }
}
