class EmailOTPVerificationRequest {
  String emailAddress;
  String otpNumber;

  EmailOTPVerificationRequest({this.emailAddress, this.otpNumber});

  EmailOTPVerificationRequest.fromJson(Map<String, dynamic> json)
      : emailAddress = json['emailAddress'],
        otpNumber = json['otpNumber'];

  Map<String, dynamic> toJson() => {'emailAddress': emailAddress, 'otpNumber': otpNumber};
}
