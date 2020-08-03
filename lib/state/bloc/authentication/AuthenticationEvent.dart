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

class RegisterUsingMobileNumberEvent extends AuthenticationEvent {
  final String mobileNumber;
  final Function callback;

  const RegisterUsingMobileNumberEvent({this.mobileNumber, this.callback});

  @override
  List<Object> get props => [mobileNumber];

  @override
  String toString() => 'RegisterUsingMobileNumberEvent {mobileNumber: $mobileNumber}';
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
  final Function callback;

  const LoginUsingMobileNumberEvent({this.mobileNo, this.callback});

  @override
  List<Object> get props => [mobileNo];

  @override
  String toString() => 'LoginUsingMobileNumberEvent {mobileNo: $mobileNo}';
}

class VerifyMobileNoEvent extends AuthenticationEvent {
  final String mobileNo;
  final String secureKeyword;
  final String otpNumber;
  final Function callback;

  const VerifyMobileNoEvent({this.mobileNo, this.secureKeyword, this.otpNumber, this.callback});

  @override
  List<Object> get props => [mobileNo];

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


class AddAuthenticationEvent extends AuthenticationEvent {
  final String jwtToken;
  final Function callback;

  const AddAuthenticationEvent({this.jwtToken, this.callback});

  @override
  List<Object> get props => [jwtToken];

  @override
  String toString() => 'AddAuthenticationEvent {jwtToken: $jwtToken}';
}

class EditAuthenticationEvent extends AuthenticationEvent {
  final String jwtToken;
  final Function callback;

  const EditAuthenticationEvent({this.jwtToken, this.callback});

  @override
  List<Object> get props => [jwtToken];

  @override
  String toString() => 'EditAuthenticationEvent {jwtToken: $jwtToken}';
}

class DeleteAuthenticationEvent extends AuthenticationEvent {
  final String jwtToken;
  final Function callback;

  const DeleteAuthenticationEvent(this.jwtToken, this.callback);

  @override
  List<Object> get props => [jwtToken];

  @override
  String toString() => 'DeleteAuthenticationEvent {jwtToken: $jwtToken}';
}
