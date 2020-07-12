import 'dart:async';

import 'package:snschat_flutter/environments/development/variables.dart' as globals;
import 'package:snschat_flutter/objects/rest/index.dart';
import 'package:snschat_flutter/rest/customHttpClient/CustomHttpClient.dart';

class UserAuthenticationAPIService {
  String REST_URL = globals.REST_URL;
  String authenticationAPI = "authentication";

  CustomHttpClient httpClient = new CustomHttpClient();

  Future<PreVerifyMobileNumberOTPResponse> registerUsingMobileNumber(RegisterUsingMobileNumberRequest registerUsingMobileNumberRequest) async {
    return PreVerifyMobileNumberOTPResponse.fromJson(await httpClient.postRequest("$REST_URL/$authenticationAPI/register/mobileNumber", requestBody: registerUsingMobileNumberRequest));
  }

  Future<UserAuthenticationResponse> addUsernamePasswordAuthenticationRequest(UsernamePasswordUserAuthenticationRequest mobileNoAuthenticationRequest) async {
    return UserAuthenticationResponse.fromJson(await httpClient.postRequest("$REST_URL/$authenticationAPI/", requestBody: mobileNoAuthenticationRequest));
  }

  Future<OTPResponse> requestToAuthenticateWithMobileNo(MobileNoUserAuthenticationRequest mobileNoAuthenticationRequest) async {
    return OTPResponse.fromJson(await httpClient.postRequest("$REST_URL/$authenticationAPI/request/mobileNumber", requestBody: mobileNoAuthenticationRequest));
  }

  Future<OTPResponse> requestToAuthenticateWithEmailAddress(EmailAddressUserAuthenticationRequest emailAddressUserAuthenticationRequest) async {
    return OTPResponse.fromJson(await httpClient.postRequest("$REST_URL/$authenticationAPI/request/emailAddress", requestBody: emailAddressUserAuthenticationRequest));
  }

  Future<UserAuthenticationResponse> usernamePasswordAuthentication(UsernamePasswordUserAuthenticationRequest mobileNoAuthenticationRequest) async {
    return UserAuthenticationResponse.fromJson(await httpClient.postRequest("$REST_URL/$authenticationAPI/usernamePassword", requestBody: mobileNoAuthenticationRequest));
  }

  Future<PreVerifyMobileNumberOTPResponse> preVerifyMobileNumber(PreVerifyMobileNumberOTPRequest preVerifyMobileNumberOTPRequest) async {
    return PreVerifyMobileNumberOTPResponse.fromJson(await httpClient.postRequest("$REST_URL/$authenticationAPI/mobileNumber/preAuthenticate", requestBody: preVerifyMobileNumberOTPRequest));
  }

  Future<UserAuthenticationResponse> mobileNumberAuthentication(VerifyMobileNumberOTPRequest verifyMobileNumberOTPRequest) async {
    return UserAuthenticationResponse.fromJson(await httpClient.postRequest("$REST_URL/$authenticationAPI/mobileNumber/authenticate", requestBody: verifyMobileNumberOTPRequest));
  }

  Future<VerifyEmailAddressResponse> requestVerifyEmailAddress(VerifyEmailAddressRequest verifyMobileNumberOTPRequest) async {
    return VerifyEmailAddressResponse.fromJson(await httpClient.postRequest("$REST_URL/$authenticationAPI/mobileNumber/authenticate", requestBody: verifyMobileNumberOTPRequest));
  }
}
