import 'package:equatable/equatable.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationsLoading extends AuthenticationState {}

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

class AuthenticationsNotLoaded extends AuthenticationState {}
