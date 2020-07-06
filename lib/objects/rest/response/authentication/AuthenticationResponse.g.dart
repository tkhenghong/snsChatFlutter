// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AuthenticationResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthenticationResponse _$AuthenticationResponseFromJson(
    Map<String, dynamic> json) {
  return AuthenticationResponse(
    jwt: json['jwt'] as String,
  );
}

Map<String, dynamic> _$AuthenticationResponseToJson(
        AuthenticationResponse instance) =>
    <String, dynamic>{
      'jwt': instance.jwt,
    };

// **************************************************************************
// DataGenerator
// **************************************************************************

abstract class _$AuthenticationResponseLombok {
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
