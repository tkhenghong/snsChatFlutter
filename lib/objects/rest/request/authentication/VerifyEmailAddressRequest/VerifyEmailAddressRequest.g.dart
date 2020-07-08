// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'VerifyEmailAddressRequest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerifyEmailAddressRequest _$VerifyEmailAddressRequestFromJson(
    Map<String, dynamic> json) {
  return VerifyEmailAddressRequest(
    username: json['username'] as String,
    password: json['password'] as String,
  );
}

Map<String, dynamic> _$VerifyEmailAddressRequestToJson(
        VerifyEmailAddressRequest instance) =>
    <String, dynamic>{
      'username': instance.username,
      'password': instance.password,
    };

// **************************************************************************
// DataGenerator
// **************************************************************************

abstract class _$VerifyEmailAddressRequestLombok {
  /// Field
  String username;
  String password;

  /// Setter

  void setUsername(String username) {
    this.username = username;
  }

  void setPassword(String password) {
    this.password = password;
  }

  /// Getter
  String getUsername() {
    return username;
  }

  String getPassword() {
    return password;
  }
}
