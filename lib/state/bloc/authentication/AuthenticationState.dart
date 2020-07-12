import 'package:equatable/equatable.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationsLoading extends AuthenticationState {}

class Authenticating extends AuthenticationState {
  final String mobileNumber;
  final String emailAddress;
  final String secureKeyword;
  final DateTime tokenExpiryTime;

  const Authenticating([this.mobileNumber, this.emailAddress, this.secureKeyword, this.tokenExpiryTime]);

  @override
  List<Object> get props => [mobileNumber, emailAddress, secureKeyword, tokenExpiryTime];

  @override
  String toString() => 'Authenticating {mobileNumber: $mobileNumber, emailAddress: $emailAddress, secureKeyword: $secureKeyword, tokenExpiryTime: ${tokenExpiryTime.toIso8601String()}';
}

// UserAuthenticationVerified
class AuthenticationsLoaded extends AuthenticationState {
  final String jwtToken;
  final String userId;
  final DateTime otpExpirationTime;

  const AuthenticationsLoaded([this.jwtToken, this.userId, this.otpExpirationTime]);

  @override
  List<Object> get props => [jwtToken, userId, otpExpirationTime];

  @override
  String toString() => 'AuthenticationsLoaded {jwtToken: $jwtToken, userId: $userId, otpExpirationTime: $otpExpirationTime}';
}

// UserAuthenticationNotVerified
class AuthenticationsNotLoaded extends AuthenticationState {}
