import 'package:hotel_flutter/data/model/signup_model.dart';

abstract class AuthEvent {}

class SignUpEvent extends AuthEvent {
  final SignUpModel signUpModel;

  SignUpEvent(this.signUpModel);
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  LoginEvent({required this.email, required this.password});
}

class ForgotPasswordEvent extends AuthEvent {
  final String email;

  ForgotPasswordEvent(this.email);
}

class ResetPasswordEvent extends AuthEvent {
  final String token;
  final String newPassword;
  final String confirmPassword;

  ResetPasswordEvent(this.token, this.newPassword, this.confirmPassword);
}

class GetUserEvent extends AuthEvent {
  final String userId;

  GetUserEvent(this.userId);
}

class LogoutEvent extends AuthEvent {}
