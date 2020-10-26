// Idea from Official Documentation. Link: https://bloclibrary.dev/#/fluttertodostutorial
import 'package:equatable/equatable.dart';

abstract class AuthenticationEvent extends Equatable {
  @override
  List<Object> get props => [];

  const AuthenticationEvent();
}

class InitializeAuthenticationsEvent extends AuthenticationEvent {
  final Function callback;

  const InitializeAuthenticationsEvent({this.callback});

  @override
  String toString() => 'InitializeAuthenticationsEvent';
}

class RegisterUsingMobileNoEvent extends AuthenticationEvent {
  final String mobileNo;
  final String countryCode;
  final Function callback;

  const RegisterUsingMobileNoEvent({this.mobileNo, this.countryCode, this.callback});

  @override
  List<Object> get props => [mobileNo, countryCode];

  @override
  String toString() => 'RegisterUsingMobileNoEvent {mobileNo: $mobileNo, countryCode: $countryCode}';
}

class LoginUsingMobileNumberEvent extends AuthenticationEvent {
  final String mobileNo;
  final String countryCode;
  final Function callback;

  const LoginUsingMobileNumberEvent({this.mobileNo, this.countryCode, this.callback});

  @override
  List<Object> get props => [mobileNo, countryCode];

  @override
  String toString() => 'LoginUsingMobileNumberEvent {mobileNo: $mobileNo, countryCode: $countryCode}';
}

class VerifyMobileNoEvent extends AuthenticationEvent {
  final String mobileNo;
  final String secureKeyword;
  final String otpNumber;
  final Function callback;

  const VerifyMobileNoEvent({this.mobileNo, this.secureKeyword, this.otpNumber, this.callback});

  @override
  List<Object> get props => [mobileNo, secureKeyword, otpNumber];

  @override
  String toString() => 'VerifyMobileNoEvent {mobileNo: $mobileNo, secureKeyword: $secureKeyword, otpNumber: $otpNumber}';
}

class RequestAuthenticationUsingEmailAddressEvent extends AuthenticationEvent {
  final String emailAddress;
  final Function callback;

  const RequestAuthenticationUsingEmailAddressEvent({this.emailAddress, this.callback});

  @override
  List<Object> get props => [emailAddress];

  @override
  String toString() => 'GetAuthenticationEventUsingMobileNo {emailAddress: $emailAddress}';
}

class RemoveAllAuthenticationsEvent extends AuthenticationEvent {
  final Function callback;

  const RemoveAllAuthenticationsEvent({this.callback});

  @override
  List<Object> get props => [];

  @override
  String toString() => 'RemoveAllAuthenticationsEvent';
}
