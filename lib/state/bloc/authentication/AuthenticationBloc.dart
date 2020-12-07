import 'package:bloc/bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snschat_flutter/general/index.dart';
import 'package:snschat_flutter/objects/rest/index.dart';
import 'package:snschat_flutter/rest/index.dart';

import 'bloc.dart';

// Idea from Official Documentation. Link: https://bloclibrary.dev/#/fluttertodostutorial
class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(AuthenticationsLoading());

  UserAuthenticationAPIService authenticationAPIService = Get.find();

  // NOTE: Do not use Get.find() for SharedPreferences. It will cause problem in Production mode.
  FlutterSecureStorage storage = Get.find();

  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent event) async* {
    if (event is InitializeAuthenticationsEvent) {
      yield* _mapInitializeAuthentication(event);
    } else if (event is RemoveAllAuthenticationsEvent) {
      yield* _removeAllAuthenticationsEvent(event);
    } else if (event is RequestAuthenticationUsingEmailAddressEvent) {
      yield* _requestAuthenticationUsingEmail(event);
    } else if (event is RegisterUsingMobileNoEvent) {
      yield* _registerUsingMobileNo(event);
    } else if (event is LoginUsingMobileNumberEvent) {
      yield* _loginUsingMobileNumber(event);
    } else if (event is VerifyMobileNoEvent) {
      yield* _verifyMobileNo(event);
    }
  }

  Stream<AuthenticationState> _mapInitializeAuthentication(InitializeAuthenticationsEvent event) async* {
    if (state is AuthenticationsLoading || state is AuthenticationsNotLoaded) {
      try {
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        String jwtToken = await storage.read(key: "jwtToken");
        String username = sharedPreferences.getString("username");
        DateTime otpExpirationTime = DateTime.parse(sharedPreferences.getString("otpExpirationTime"));

        bool jwtExpired = otpExpirationTime.isBefore(DateTime.now());

        if (!jwtToken.isNullOrBlank && !username.isNullOrBlank && !otpExpirationTime.isNull && !jwtExpired) {
          yield AuthenticationsLoaded(jwtToken, username, otpExpirationTime);
          functionCallback(event, true);
        } else {
          storage.delete(key: 'jwtToken');
          storage.delete(key: 'username');
          sharedPreferences.remove('otpExpirationTime');
          yield AuthenticationsNotLoaded();
          functionCallback(event, false);
        }
      } catch (e) {
        yield AuthenticationsNotLoaded();
        functionCallback(event, false);
      }
    }
  }

  // Only used when changing mobile number
  Stream<AuthenticationState> _requestAuthenticationUsingEmail(RequestAuthenticationUsingEmailAddressEvent event) async* {
    OTPResponse otpResponse = await authenticationAPIService.requestToAuthenticateWithEmailAddress(new EmailAddressUserAuthenticationRequest(emailAddress: event.emailAddress));
    if (!otpResponse.isNull) {
      String toastContent = 'Verification code has been sent to email address: ${event.emailAddress} successfully! Please check your email.';
      showToast(toastContent, Toast.LENGTH_SHORT);
      yield Authenticating(null, event.emailAddress, null, null, event.emailAddress, null, otpResponse.otpExpirationDateTime, VerificationMode.ChangeEmailAddress);
    } else {
      showToast("Error when request OTP.", Toast.LENGTH_SHORT);
    }
  }

  // Register Step 1
  Stream<AuthenticationState> _registerUsingMobileNo(RegisterUsingMobileNoEvent event) async* {
    PreVerifyMobileNumberOTPResponse preVerifyMobileNumberOTPResponse = await authenticationAPIService.registerMobileNumber(new RegisterUsingMobileNumberRequest(mobileNo: event.mobileNo, countryCode: event.countryCode));
    if (!preVerifyMobileNumberOTPResponse.isNull) {
      String toastContent = 'A verification code has been sent to your mobile no.: ${event.mobileNo}.';
      showToast(toastContent, Toast.LENGTH_SHORT);
      yield Authenticating(event.mobileNo, event.countryCode, null, preVerifyMobileNumberOTPResponse.maskedMobileNumber, preVerifyMobileNumberOTPResponse.maskedEmailAddress, preVerifyMobileNumberOTPResponse.secureKeyword,
          preVerifyMobileNumberOTPResponse.tokenExpiryTime, VerificationMode.SignUp);
    } else {
      showToast("Error when request OTP.", Toast.LENGTH_SHORT);
      yield AuthenticationsNotLoaded();
    }

    functionCallback(event, preVerifyMobileNumberOTPResponse);
  }

  // Login Step 1
  Stream<AuthenticationState> _loginUsingMobileNumber(LoginUsingMobileNumberEvent event) async* {
    PreVerifyMobileNumberOTPResponse preVerifyMobileNumberOTPResponse = await authenticationAPIService.loginMobileNumber(new PreVerifyMobileNumberOTPRequest(mobileNumber: event.mobileNo));
    if (!preVerifyMobileNumberOTPResponse.isNull) {
      String toastContent = 'A verification code has been sent to your mobile no.: ${event.mobileNo}.';
      showToast(toastContent, Toast.LENGTH_SHORT);
      yield Authenticating(event.mobileNo, event.countryCode, null, preVerifyMobileNumberOTPResponse.maskedMobileNumber, preVerifyMobileNumberOTPResponse.maskedEmailAddress, preVerifyMobileNumberOTPResponse.secureKeyword,
          preVerifyMobileNumberOTPResponse.tokenExpiryTime, VerificationMode.Login);
    } else {
      showToast("Error when request OTP.", Toast.LENGTH_SHORT);
      yield AuthenticationsNotLoaded();
    }

    functionCallback(event, preVerifyMobileNumberOTPResponse);
  }

  // Login / Register Step 2
  Stream<AuthenticationState> _verifyMobileNo(VerifyMobileNoEvent event) async* {
    if (state is Authenticating) {
      Authenticating authenticating = state as Authenticating;

      VerifyMobileNumberOTPRequest verifyMobileNumberOTPRequest = new VerifyMobileNumberOTPRequest(mobileNo: event.mobileNo, otpNumber: event.otpNumber, secureKeyword: event.secureKeyword);
      UserAuthenticationResponse userAuthenticationResponse;

      switch (authenticating.verificationMode) {
        case VerificationMode.Login:
          userAuthenticationResponse = await authenticationAPIService.loginMobileNumberOTPVerification(verifyMobileNumberOTPRequest);
          break;
        case VerificationMode.SignUp:
          userAuthenticationResponse = await authenticationAPIService.registerMobileNumberOTPVerification(verifyMobileNumberOTPRequest);
          break;
      }

      if (!userAuthenticationResponse.isNull) {
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        await storage.write(key: "jwtToken", value: userAuthenticationResponse.jwt);
        sharedPreferences.setString("username", userAuthenticationResponse.username);
        sharedPreferences.setString("otpExpirationTime", userAuthenticationResponse.otpExpirationTime.toString());
        yield AuthenticationsLoaded(userAuthenticationResponse.jwt, userAuthenticationResponse.username, userAuthenticationResponse.otpExpirationTime);
      }

      functionCallback(event, userAuthenticationResponse);
    }
  }

  Stream<AuthenticationState> _removeAllAuthenticationsEvent(RemoveAllAuthenticationsEvent event) async* {
    storage.deleteAll();

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove('username');
    sharedPreferences.remove('otpExpirationTime');

    yield AuthenticationsNotLoaded();
    functionCallback(event, true);
  }

  void functionCallback(event, value) {
    if (!isObjectEmpty(event) && !isObjectEmpty(event.callback)) {
      event.callback(value);
    }
  }
}
