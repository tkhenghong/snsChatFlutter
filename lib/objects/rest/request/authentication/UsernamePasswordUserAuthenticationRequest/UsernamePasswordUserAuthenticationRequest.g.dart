// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UsernamePasswordUserAuthenticationRequest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UsernamePasswordUserAuthenticationRequest
    _$UsernamePasswordUserAuthenticationRequestFromJson(
        Map<String, dynamic> json) {
  return UsernamePasswordUserAuthenticationRequest(
    username: json['username'] as String,
    password: json['password'] as String,
  );
}

Map<String, dynamic> _$UsernamePasswordUserAuthenticationRequestToJson(
        UsernamePasswordUserAuthenticationRequest instance) =>
    <String, dynamic>{
      'username': instance.username,
      'password': instance.password,
    };

// **************************************************************************
// DataGenerator
// **************************************************************************

abstract class _$UsernamePasswordUserAuthenticationRequestLombok {
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
