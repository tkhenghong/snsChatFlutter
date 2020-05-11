class MobileNoAuthenticationRequest {
  String mobileNo;

  MobileNoAuthenticationRequest({this.mobileNo});

  MobileNoAuthenticationRequest.fromJson(Map<String, dynamic> json)
      : mobileNo = json['mobileNo'];

  Map<String, dynamic> toJson() => {'mobileNo': mobileNo};
}
