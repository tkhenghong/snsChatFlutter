import 'package:equatable/equatable.dart';
import 'package:snschat_flutter/general/index.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationsLoading extends AuthenticationState {}

class Authenticating extends AuthenticationState {
  final String mobileNumber;
  final String countryCode;
  final String emailAddress;
  final String maskedMobileNumber;
  final String maskedEmailAddress;
  final String secureKeyword;
  final DateTime tokenExpiryTime;
  final VerificationMode verificationMode;

  const Authenticating([this.mobileNumber, this.countryCode, this.emailAddress, this.maskedMobileNumber, this.maskedEmailAddress, this.secureKeyword, this.tokenExpiryTime, this.verificationMode]);

  @override
  List<Object> get props => [mobileNumber, countryCode, emailAddress, secureKeyword, tokenExpiryTime, verificationMode];

  @override
  String toString() => 'Authenticating {mobileNumber: $mobileNumber, countryCode: $countryCode, emailAddress: $emailAddress, maskedMobileNumber: $maskedMobileNumber, maskedEmailAddress: $maskedEmailAddress, secureKeyword: $secureKeyword, '
      'tokenExpiryTime: '
      '${tokenExpiryTime.toIso8601String()}, verificationMode: $verificationMode}';
}

class AuthenticationsLoaded extends AuthenticationState {
  final String jwtToken;
  final String username;
  final DateTime otpExpirationTime;

  const AuthenticationsLoaded([this.jwtToken, this.username, this.otpExpirationTime]);

  @override
  List<Object> get props => [jwtToken, username, otpExpirationTime];

  @override
  String toString() => 'AuthenticationsLoaded {jwtToken: $jwtToken, username: $username, otpExpirationTime: $otpExpirationTime}';
}

class AuthenticationsNotLoaded extends AuthenticationState {}
