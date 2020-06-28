class EmailAddressAuthenticationRequest {
  String emailAddress;

  EmailAddressAuthenticationRequest({this.emailAddress});

  EmailAddressAuthenticationRequest.fromJson(Map<String, dynamic> json) : emailAddress = json['emailAddress'];

  Map<String, dynamic> toJson() => {'emailAddress': emailAddress};
}
