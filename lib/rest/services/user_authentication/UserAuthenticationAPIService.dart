import 'dart:async';

import 'package:get/get.dart';
import 'package:snschat_flutter/environments/development/variables.dart' as globals;
import 'package:snschat_flutter/objects/rest/index.dart';
import 'package:snschat_flutter/rest/custom_http_client/custom_http_client.dart';

class UserAuthenticationAPIService {
  String REST_URL = globals.REST_URL;
  String authenticationAPI = 'authentication';

  CustomHttpClient httpClient = Get.find();

  Future<bool> checkIsAuthenticated() async {
    return await httpClient.getRequest('$REST_URL/$authenticationAPI');
  }
  
  // Register Step 1
  Future<PreVerifyMobileNumberOTPResponse> registerMobileNumber(RegisterUsingMobileNumberRequest registerUsingMobileNumberRequest) async {
    return PreVerifyMobileNumberOTPResponse.fromJson(await httpClient.postRequest('$REST_URL/$authenticationAPI/register/mobileNumber', requestBody: registerUsingMobileNumberRequest));
  }

  // Register Step 2
  Future<UserAuthenticationResponse> registerMobileNumberOTPVerification(VerifyMobileNumberOTPRequest verifyMobileNumberOTPRequest) async {
    return UserAuthenticationResponse.fromJson(await httpClient.postRequest('$REST_URL/$authenticationAPI/register/mobileNumber/authenticate', requestBody: verifyMobileNumberOTPRequest));
  }

  // Login Step 1
  Future<PreVerifyMobileNumberOTPResponse> loginMobileNumber(PreVerifyMobileNumberOTPRequest preVerifyMobileNumberOTPRequest) async {
    return PreVerifyMobileNumberOTPResponse.fromJson(await httpClient.postRequest('$REST_URL/$authenticationAPI/login/mobileNumber', requestBody: preVerifyMobileNumberOTPRequest));
  }

  // Login Step 2
  Future<UserAuthenticationResponse> loginMobileNumberOTPVerification(VerifyMobileNumberOTPRequest verifyMobileNumberOTPRequest) async {
    return UserAuthenticationResponse.fromJson(await httpClient.postRequest('$REST_URL/$authenticationAPI/login/mobileNumber/authenticate', requestBody: verifyMobileNumberOTPRequest));
  }

  Future<VerifyEmailAddressResponse> requestVerifyEmailAddress(VerifyEmailAddressRequest verifyMobileNumberOTPRequest) async {
    return VerifyEmailAddressResponse.fromJson(await httpClient.postRequest('$REST_URL/$authenticationAPI/mobileNumber/authenticate', requestBody: verifyMobileNumberOTPRequest));
  }

  Future<OTPResponse> requestToAuthenticateWithMobileNo(MobileNoUserAuthenticationRequest mobileNoAuthenticationRequest) async {
    return OTPResponse.fromJson(await httpClient.postRequest('$REST_URL/$authenticationAPI/request/mobileNumber', requestBody: mobileNoAuthenticationRequest));
  }

  Future<OTPResponse> requestToAuthenticateWithEmailAddress(EmailAddressUserAuthenticationRequest emailAddressUserAuthenticationRequest) async {
    return OTPResponse.fromJson(await httpClient.postRequest('$REST_URL/$authenticationAPI/request/emailAddress', requestBody: emailAddressUserAuthenticationRequest));
  }

  Future<UserAuthenticationResponse> addUsernamePasswordAuthenticationRequest(UsernamePasswordUserAuthenticationRequest mobileNoAuthenticationRequest) async {
    return UserAuthenticationResponse.fromJson(await httpClient.postRequest('$REST_URL/$authenticationAPI', requestBody: mobileNoAuthenticationRequest));
  }

  Future<UserAuthenticationResponse> usernamePasswordAuthentication(UsernamePasswordUserAuthenticationRequest mobileNoAuthenticationRequest) async {
    return UserAuthenticationResponse.fromJson(await httpClient.postRequest('$REST_URL/$authenticationAPI/usernamePassword', requestBody: mobileNoAuthenticationRequest));
  }
}
