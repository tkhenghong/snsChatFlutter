import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:snschat_flutter/environments/development/variables.dart'
as globals;
import 'package:snschat_flutter/objects/rest/index.dart';

import '../RestRequestUtils.dart';
import '../RestResponseUtils.dart';

class AuthenticationAPIService {
  String REST_URL = globals.REST_URL;
  String authenticationAPI = "authentication";

  Future<OTPResponse> requestToAuthenticateWithMobileNo(MobileNoAuthenticationRequest mobileNoAuthenticationRequest) async {
    String wholeURL = "$REST_URL/$authenticationAPI/request/mobileNumber";
    String mobileNoAuthenticationRequestString = json.encode(mobileNoAuthenticationRequest.toJson());
    var httpResponse = await http.post(wholeURL, body: mobileNoAuthenticationRequestString, headers: createAcceptJSONHeader());
    return getOTPResponseBody(httpResponse);
  }

  Future<OTPResponse> requestToAuthenticateWithEmailAddress(EmailAddressAuthenticationRequest emailAddressAuthenticationRequest) async {
    String wholeURL = "$REST_URL/$authenticationAPI/request/emailAddress";
    String emailAddressAuthenticationRequestString = json.encode(emailAddressAuthenticationRequest.toJson());
    var httpResponse = await http.post(wholeURL, body: emailAddressAuthenticationRequestString, headers: createAcceptJSONHeader());
    return getOTPResponseBody(httpResponse);
  }

  Future<AuthenticationResponse> emailAuthentication(EmailOTPVerificationRequest emailOTPVerificationRequest) async {
    String wholeURL = "$REST_URL/$authenticationAPI/emailAddress/authenticate";
    String emailOTPVerificationRequestString = json.encode(emailOTPVerificationRequest.toJson());
    var httpResponse = await http.post(wholeURL, body: emailOTPVerificationRequestString, headers: createAcceptJSONHeader());
    return getAuthenticationResponseBody(httpResponse);
  }

  Future<AuthenticationResponse> mobileNumberAuthentication(MobileNumberOTPVerificationRequest mobileNumberOTPVerificationRequest) async {
    String wholeURL = "$REST_URL/$authenticationAPI/mobileNumber/authenticate";
    String mobileNumberOTPVerificationRequestString = json.encode(mobileNumberOTPVerificationRequest.toJson());
    var httpResponse = await http.post(wholeURL, body: mobileNumberOTPVerificationRequestString, headers: createAcceptJSONHeader());
    return getAuthenticationResponseBody(httpResponse);
  }

  OTPResponse getOTPResponseBody(Response httpResponse) {
    if (httpResponseIsOK(httpResponse)) {
      OTPResponse otpResponse = new OTPResponse.fromJson(json.decode(httpResponse.body));
      return otpResponse;
    }
    return null;
  }

  AuthenticationResponse getAuthenticationResponseBody(Response httpResponse) {
    if (httpResponseIsOK(httpResponse)) {
      AuthenticationResponse authenticationResponse = new AuthenticationResponse.fromJson(json.decode(httpResponse.body));
      return authenticationResponse;
    }
    return null;
  }
}
