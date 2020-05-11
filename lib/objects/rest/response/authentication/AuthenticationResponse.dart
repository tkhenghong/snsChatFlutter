class AuthenticationResponse {
  String jwt;

  AuthenticationResponse({this.jwt});

  AuthenticationResponse.fromJson(Map<String, dynamic> json)
      : jwt = json['jwt'];

  Map<String, dynamic> toJson() => {'jwt': jwt};
}
