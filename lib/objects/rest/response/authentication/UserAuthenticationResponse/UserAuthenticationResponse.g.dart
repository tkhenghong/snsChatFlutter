// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserAuthenticationResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserAuthenticationResponse _$UserAuthenticationResponseFromJson(
    Map<String, dynamic> json) {
  return UserAuthenticationResponse(
    jwt: json['jwt'] as String,
  );
}

Map<String, dynamic> _$UserAuthenticationResponseToJson(
        UserAuthenticationResponse instance) =>
    <String, dynamic>{
      'jwt': instance.jwt,
    };

// **************************************************************************
// DataGenerator
// **************************************************************************

abstract class _$UserAuthenticationResponseLombok {
  /// Field
  String jwt;

  /// Setter

  void setJwt(String jwt) {
    this.jwt = jwt;
  }

  /// Getter
  String getJwt() {
    return jwt;
  }
}
