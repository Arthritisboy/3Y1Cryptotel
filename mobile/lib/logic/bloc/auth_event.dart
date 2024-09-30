import 'package:hotel_flutter/data/model/signup_model.dart';

abstract class AuthEvent {}

class SignUpEvent extends AuthEvent {
  final SignUpModel signUpModel;

  SignUpEvent(this.signUpModel);
}

class AuthLoadingEvent extends AuthEvent {}

class AuthenticatedEvent extends AuthEvent {}

class AuthErrorEvent extends AuthEvent {
  final String error;

  AuthErrorEvent(this.error);
}
