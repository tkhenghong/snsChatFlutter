import 'dart:async';

import 'package:snschat_flutter/environments/development/variables.dart' as globals;
import 'package:snschat_flutter/objects/rest/index.dart';
import 'package:snschat_flutter/rest/httpClient/HttpClient.dart';

class AuthenticationAPIService {
  String REST_URL = globals.REST_URL;
  String authenticationAPI = "authentication";

  HttpClient httpClient = new HttpClient();

  Future<UserAuthenticationResponse> addUsernamePasswordAuthenticationRequest(UsernamePasswordUserAuthenticationRequest mobileNoAuthenticationRequest) async {
    String wholeURL = "$REST_URL/$authenticationAPI/";
    UserAuthenticationResponse authenticationResponse = await httpClient.postRequest(wholeURL, requestBody: mobileNoAuthenticationRequest);
    return authenticationResponse;
  }

  Future<OTPResponse> requestToAuthenticateWithMobileNo(MobileNoUserAuthenticationRequest mobileNoAuthenticationRequest) async {
    String wholeURL = "$REST_URL/$authenticationAPI/request/mobileNumber";
    OTPResponse otpResponse = await httpClient.postRequest(wholeURL, requestBody: mobileNoAuthenticationRequest);
    return otpResponse;
  }

  Future<OTPResponse> requestToAuthenticateWithEmailAddress(EmailAddressUserAuthenticationRequest emailAddressUserAuthenticationRequest) async {
    String wholeURL = "$REST_URL/$authenticationAPI/request/emailAddress";
    OTPResponse otpResponse = await httpClient.postRequest(wholeURL, requestBody: emailAddressUserAuthenticationRequest);
    return otpResponse;
  }

  Future<UserAuthenticationResponse> usernamePasswordAuthentication(UsernamePasswordUserAuthenticationRequest mobileNoAuthenticationRequest) async {
    String wholeURL = "$REST_URL/$authenticationAPI/usernamePassword";
    UserAuthenticationResponse authenticationResponse = await httpClient.postRequest(wholeURL, requestBody: mobileNoAuthenticationRequest);
    return authenticationResponse;
  }

  Future<PreVerifyMobileNumberOTPResponse> preVerifyMobileNumber(PreVerifyMobileNumberOTPRequest preVerifyMobileNumberOTPRequest) async {
    String wholeURL = "$REST_URL/$authenticationAPI/mobileNumber/preAuthenticate";
    PreVerifyMobileNumberOTPResponse preVerifyMobileNumberOTPResponse = await httpClient.postRequest(wholeURL, requestBody: preVerifyMobileNumberOTPRequest);
    return preVerifyMobileNumberOTPResponse;
  }

  Future<UserAuthenticationResponse> mobileNumberAuthentication(VerifyMobileNumberOTPRequest verifyMobileNumberOTPRequest) async {
    String wholeURL = "$REST_URL/$authenticationAPI/mobileNumber/authenticate";
    UserAuthenticationResponse authenticationResponse = await httpClient.postRequest(wholeURL, requestBody: verifyMobileNumberOTPRequest);
    return authenticationResponse;
  }

  Future<VerifyEmailAddressResponse> requestVerifyEmailAddress(VerifyEmailAddressRequest verifyMobileNumberOTPRequest) async {
    String wholeURL = "$REST_URL/$authenticationAPI/mobileNumber/authenticate";
    VerifyEmailAddressResponse verifyEmailAddressResponse = await httpClient.postRequest(wholeURL, requestBody: verifyMobileNumberOTPRequest);
    return verifyEmailAddressResponse;
  }

}
