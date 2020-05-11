class MobileNumberOTPVerificationRequest {
  String mobileNo;
  String otpNumber;

  MobileNumberOTPVerificationRequest({this.mobileNo, this.otpNumber});

  MobileNumberOTPVerificationRequest.fromJson(Map<String, dynamic> json)
      : mobileNo = json['mobileNo'],
        otpNumber = json['otpNumber'];

  Map<String, dynamic> toJson() =>
      {'mobileNo': mobileNo, 'otpNumber': otpNumber};
}
