import 'dart:async';

import 'package:snschat_flutter/environments/development/variables.dart' as globals;
import 'package:snschat_flutter/objects/rest/index.dart';
import 'package:snschat_flutter/rest/httpClient/HttpClient.dart';

class AuthenticationAPIService {
  String REST_URL = globals.REST_URL;
  String authenticationAPI = "authentication";

  HttpClient httpClient = new HttpClient();

  Future<OTPResponse> requestToAuthenticateWithMobileNo(MobileNoAuthenticationRequest mobileNoAuthenticationRequest) async {
    String wholeURL = "$REST_URL/$authenticationAPI/request/mobileNumber";
    OTPResponse otpResponse = await httpClient.postRequest(wholeURL, requestBody: mobileNoAuthenticationRequest);
    return otpResponse;
  }

  Future<OTPResponse> requestToAuthenticateWithEmailAddress(EmailAddressAuthenticationRequest emailAddressAuthenticationRequest) async {
    String wholeURL = "$REST_URL/$authenticationAPI/request/emailAddress";
    OTPResponse otpResponse = await httpClient.postRequest(wholeURL, requestBody: emailAddressAuthenticationRequest);
    return otpResponse;
  }

  Future<AuthenticationResponse> emailAuthentication(EmailOTPVerificationRequest emailOTPVerificationRequest) async {
    String wholeURL = "$REST_URL/$authenticationAPI/emailAddress/authenticate";
    AuthenticationResponse authenticationResponse = await httpClient.postRequest(wholeURL, requestBody: emailOTPVerificationRequest);
    return authenticationResponse;
  }

  Future<AuthenticationResponse> mobileNumberAuthentication(MobileNumberOTPVerificationRequest mobileNumberOTPVerificationRequest) async {
    String wholeURL = "$REST_URL/$authenticationAPI/mobileNumber/authenticate";
    AuthenticationResponse authenticationResponse = await httpClient.postRequest(wholeURL, requestBody: mobileNumberOTPVerificationRequest);
    return authenticationResponse;
  }

//  OTPResponse getOTPResponseBody(Response httpResponse) {
//    if (httpResponseIsOK(httpResponse)) {
//      OTPResponse otpResponse = new OTPResponse.fromJson(json.decode(httpResponse.body));
//      return otpResponse;
//    }
//    return null;
//  }
//
//  AuthenticationResponse getAuthenticationResponseBody(Response httpResponse) {
//    if (httpResponseIsOK(httpResponse)) {
//      AuthenticationResponse authenticationResponse = new AuthenticationResponse.fromJson(json.decode(httpResponse.body));
//      return authenticationResponse;
//    }
//    return null;
//  }
}
