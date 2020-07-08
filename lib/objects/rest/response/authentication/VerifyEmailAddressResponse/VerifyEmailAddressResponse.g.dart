// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'VerifyEmailAddressResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerifyEmailAddressResponse _$VerifyEmailAddressResponseFromJson(
    Map<String, dynamic> json) {
  return VerifyEmailAddressResponse(
    jwt: json['jwt'] as String,
  );
}

Map<String, dynamic> _$VerifyEmailAddressResponseToJson(
        VerifyEmailAddressResponse instance) =>
    <String, dynamic>{
      'jwt': instance.jwt,
    };

// **************************************************************************
// DataGenerator
// **************************************************************************

abstract class _$VerifyEmailAddressResponseLombok {
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
