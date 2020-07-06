// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'EmailAddressAuthenticationRequest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmailAddressAuthenticationRequest _$EmailAddressAuthenticationRequestFromJson(
    Map<String, dynamic> json) {
  return EmailAddressAuthenticationRequest(
    emailAddress: json['emailAddress'] as String,
  );
}

Map<String, dynamic> _$EmailAddressAuthenticationRequestToJson(
        EmailAddressAuthenticationRequest instance) =>
    <String, dynamic>{
      'emailAddress': instance.emailAddress,
    };

// **************************************************************************
// DataGenerator
// **************************************************************************

abstract class _$EmailAddressAuthenticationRequestLombok {
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
