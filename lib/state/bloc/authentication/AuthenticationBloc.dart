import 'package:bloc/bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snschat_flutter/general/index.dart';
import 'package:snschat_flutter/objects/rest/index.dart';
import 'package:snschat_flutter/rest/models/user_authentication/UserAuthenticationAPIService.dart';

import 'bloc.dart';

// Idea from Official Documentation. Link: https://bloclibrary.dev/#/fluttertodostutorial
class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(AuthenticationsLoading());

  UserAuthenticationAPIService authenticationAPIService = Get.find();

  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent event) async* {
    // TODO: implement mapEventToState
    if (event is InitializeAuthenticationsEvent) {
      yield* _mapInitializeAuthentication(event);
    } else if (event is EditAuthenticationEvent) {
      yield* _editAuthentication(event);
    } else if (event is DeleteAuthenticationEvent) {
      yield* _deleteAuthentication(event);
    } else if (event is RequestAuthenticationUsingEmailAddressEvent) {
      yield* _requestAuthenticationUsingEmail(event);
    } else if (event is RequestAuthenticationUsingMobileNoEvent) {
      yield* _requestAuthenticationUsingMobileNo(event);
    } else if (event is VerifyAuthenticationUsingMobileNoEvent) {
      yield* _verifyAuthenticationUsingMobileNo(event);
    } else if (event is RegisterUsingMobileNoEvent) {
      yield* _registerUsingMobileNo(event);
    } else if (event is PreVerifyMobileNoEvent) {
      yield* _preVerifyMobileNo(event);
    } else if (event is VerifyMobileNoEvent) {
      yield* _verifyMobileNo(event);
    }
    // RegisterUsingMobileNoEvent
  }

  Stream<AuthenticationState> _mapInitializeAuthentication(InitializeAuthenticationsEvent event) async* {
    if (state is AuthenticationsLoading || state is AuthenticationsNotLoaded) {
      try {
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        String jwtToken = sharedPreferences.getString("jwtToken");
        String userId = sharedPreferences.getString("userId");

        if (!isStringEmpty(jwtToken) && !isStringEmpty(userId)) {
          yield AuthenticationsLoaded(jwtToken, userId);
          functionCallback(event, true);
        } else {
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
    if (!isObjectEmpty(otpResponse)) {
      String toastContent = 'Verification code has been sent to email address: ${event.emailAddress} successfully! Please check your email.';
      showToast(toastContent, Toast.LENGTH_SHORT);
      yield AuthenticationsLoaded(null, null, otpResponse.otpExpirationDateTime);
    } else {
      showToast("Error when request OTP.", Toast.LENGTH_SHORT);
      yield AuthenticationsLoaded(null, null);
    }
  }

  // Only used when changing email address
  Stream<AuthenticationState> _requestAuthenticationUsingMobileNo(RequestAuthenticationUsingMobileNoEvent event) async* {
    OTPResponse otpResponse = await authenticationAPIService.requestToAuthenticateWithMobileNo(new MobileNoUserAuthenticationRequest(mobileNo: event.mobileNumber));
    if (!isObjectEmpty(otpResponse)) {
      String toastContent = 'Verification code has been sent to mobile no.: ${event.mobileNumber} successfully! Please check your email.';
      showToast(toastContent, Toast.LENGTH_SHORT);
      yield AuthenticationsLoaded(null, null, otpResponse.otpExpirationDateTime);
    } else {
      showToast("Error when request OTP.", Toast.LENGTH_SHORT);
      yield AuthenticationsLoaded(null, null);
    }
  }

  // Only used when sign up
  Stream<AuthenticationState> _registerUsingMobileNo(RegisterUsingMobileNoEvent event) async* {
    PreVerifyMobileNumberOTPResponse preVerifyMobileNumberOTPResponse = await authenticationAPIService.registerUsingMobileNumber(new RegisterUsingMobileNumberRequest(mobileNo: event.mobileNo, countryCode: event.countryCode));
    if (!isObjectEmpty(preVerifyMobileNumberOTPResponse)) {
      String toastContent = 'A verification code has been sent to your mobile no.: ${event.mobileNo}.';
      showToast(toastContent, Toast.LENGTH_SHORT);
      yield Authenticating(preVerifyMobileNumberOTPResponse.mobileNumber, preVerifyMobileNumberOTPResponse.emailAddress, preVerifyMobileNumberOTPResponse.secureKeyword, preVerifyMobileNumberOTPResponse.tokenExpiryTime);
    } else {
      showToast("Error when request OTP.", Toast.LENGTH_SHORT);
      yield AuthenticationsNotLoaded();
    }

    functionCallback(event, preVerifyMobileNumberOTPResponse);
  }

  // Only used when sign in
  Stream<AuthenticationState> _verifyAuthenticationUsingMobileNo(VerifyAuthenticationUsingMobileNoEvent event) async* {
    UserAuthenticationResponse authenticationResponse = await authenticationAPIService.mobileNumberAuthentication(new VerifyMobileNumberOTPRequest(mobileNo: event.mobileNumber, otpNumber: event.otpNumber));
    if (!isObjectEmpty(authenticationResponse)) {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setString("jwtToken", authenticationResponse.jwt);
      yield AuthenticationsLoaded(authenticationResponse.jwt, null);
    } else {
      showToast("Error when request OTP.", Toast.LENGTH_SHORT);
      yield AuthenticationsNotLoaded();
    }
  }

  Stream<AuthenticationState> _preVerifyMobileNo(PreVerifyMobileNoEvent event) async* {
    PreVerifyMobileNumberOTPResponse preVerifyMobileNumberOTPResponse = await authenticationAPIService.preVerifyMobileNumber(new PreVerifyMobileNumberOTPRequest(mobileNumber: event.mobileNo));
    functionCallback(event, preVerifyMobileNumberOTPResponse);
  }

  Stream<AuthenticationState> _verifyMobileNo(VerifyMobileNoEvent event) async* {
    UserAuthenticationResponse userAuthenticationResponse =
        await authenticationAPIService.mobileNumberAuthentication(new VerifyMobileNumberOTPRequest(mobileNo: event.mobileNo, otpNumber: event.otpNumber, secureKeyword: event.secureKeyword));
    functionCallback(event, userAuthenticationResponse);
  }

  Stream<AuthenticationState> _editAuthentication(EditAuthenticationEvent event) async* {
    //    bool updatedInREST = false;
    //    bool saved = false;
    //    if (state is AuthenticationsLoaded) {
    //      updatedInREST = await authenticationAPIService
    //          .editAuthentication(event.Authentication);
    //
    //      if (updatedInREST) {
    //        saved = await authenticationDBService
    //            .editAuthentication(event.Authentication);
    //        if (saved) {
    //          List<Authentication> existingAuthenticationList =
    //              (state as AuthenticationsLoaded).AuthenticationList;
    //
    //          existingAuthenticationList.removeWhere(
    //              (Authentication existingAuthentication) =>
    //                  existingAuthentication.id == event.Authentication.id);
    //
    //          existingAuthenticationList.add(event.Authentication);
    //
    //          yield AuthenticationsLoaded(existingAuthenticationList);
    //          functionCallback(event, event.Authentication);
    //        }
    //      }
    //    }
    //
    //    if (!updatedInREST || !saved) {
    //      functionCallback(event, null);
    //    }
  }

  Stream<AuthenticationState> _deleteAuthentication(DeleteAuthenticationEvent event) async* {
    //    bool deletedInREST = false;
    //    bool deleted = false;
    //    if (state is AuthenticationsLoaded) {
    //      deletedInREST = await authenticationAPIService
    //          .deleteAuthentication(event.Authentication.id);
    //
    //      if (deletedInREST) {
    //        deleted = await authenticationDBService
    //            .deleteAuthentication(event.Authentication.id);
    //
    //        if (deleted) {
    //          List<Authentication> existingAuthenticationList =
    //              (state as AuthenticationsLoaded).AuthenticationList;
    //
    //          existingAuthenticationList.removeWhere(
    //              (Authentication existingAuthentication) =>
    //                  existingAuthentication.id == event.Authentication.id);
    //
    //          yield AuthenticationsLoaded(existingAuthenticationList);
    //          functionCallback(event, true);
    //        }
    //      }
    //    }
    //
    //    if (!deletedInREST || !deleted) {
    //      functionCallback(event, false);
    //    }
  }

  // To send response to those dispatched Actions
  void functionCallback(event, value) {
    if (!isObjectEmpty(event)) {
      event.callback(value);
    }
  }
}
