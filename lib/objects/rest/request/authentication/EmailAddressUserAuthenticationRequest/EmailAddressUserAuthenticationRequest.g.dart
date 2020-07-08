// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'EmailAddressUserAuthenticationRequest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmailAddressUserAuthenticationRequest
    _$EmailAddressUserAuthenticationRequestFromJson(Map<String, dynamic> json) {
  return EmailAddressUserAuthenticationRequest(
    emailAddress: json['emailAddress'] as String,
  );
}

Map<String, dynamic> _$EmailAddressUserAuthenticationRequestToJson(
        EmailAddressUserAuthenticationRequest instance) =>
    <String, dynamic>{
      'emailAddress': instance.emailAddress,
    };

// **************************************************************************
// DataGenerator
// **************************************************************************

abstract class _$EmailAddressUserAuthenticationRequestLombok {
  /// Field
  String emailAddress;

  /// Setter

  void setEmailAddress(String emailAddress) {
    this.emailAddress = emailAddress;
  }

  /// Getter
  String getEmailAddress() {
    return emailAddress;
  }
}
