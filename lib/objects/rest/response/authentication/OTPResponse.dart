class OTPResponse {
  DateTime otpExpirationDateTime;

  OTPResponse({this.otpExpirationDateTime});

  OTPResponse.fromJson(Map<String, dynamic> json)
      : otpExpirationDateTime = json['otpExpirationDateTime'];

  Map<String, dynamic> toJson() =>
      {'otpExpirationDateTime': otpExpirationDateTime};
}
