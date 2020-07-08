// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'OTPResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OTPResponse _$OTPResponseFromJson(Map<String, dynamic> json) {
  return OTPResponse(
    otpExpirationDateTime: json['otpExpirationDateTime'] == null
        ? null
        : DateTime.parse(json['otpExpirationDateTime'] as String),
  );
}

Map<String, dynamic> _$OTPResponseToJson(OTPResponse instance) =>
    <String, dynamic>{
      'otpExpirationDateTime':
          instance.otpExpirationDateTime?.toIso8601String(),
    };

// **************************************************************************
// DataGenerator
// **************************************************************************

abstract class _$OTPResponseLombok {
  /// Field
  DateTime otpExpirationDateTime;

  /// Setter

  void setOtpExpirationDateTime(DateTime otpExpirationDateTime) {
    this.otpExpirationDateTime = otpExpirationDateTime;
  }

  /// Getter
  DateTime getOtpExpirationDateTime() {
    return otpExpirationDateTime;
  }
}
