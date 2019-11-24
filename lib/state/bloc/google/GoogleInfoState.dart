import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:snschat_flutter/objects/index.dart';
import 'package:meta/meta.dart';

// Idea from Official Documentation. Link: https://bloclibrary.dev/#/fluttertodostutorial
abstract class GoogleInfoState extends Equatable {
  const GoogleInfoState();

  @override
  List<Object> get props => [];
}

class GoogleInfoLoading extends GoogleInfoState {}

class GoogleInfoLoaded extends GoogleInfoState {
  final FirebaseUser firebaseUser;
  final FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;

  const GoogleInfoLoaded([this.googleSignIn, this.firebaseAuth, this.firebaseUser]);

  @override
  List<Object> get props => [firebaseUser, firebaseAuth, googleSignIn];

  @override
  String toString() => 'GoogleInfoLoaded {firebaseUser: $firebaseUser, firebaseAuth: $firebaseAuth, googleSignIn: $googleSignIn}';
}

class GoogleInfoNotLoaded extends GoogleInfoState {}
