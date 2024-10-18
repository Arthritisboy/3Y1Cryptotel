import 'package:hotel_flutter/data/model/auth/signup_model.dart';
import 'package:hotel_flutter/data/model/auth/user_model.dart';

abstract class AuthEvent {}

class SignUpEvent extends AuthEvent {
  final SignUpModel signUpModel;
  final String? profilePicture;

  SignUpEvent(this.signUpModel, this.profilePicture);
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

class UpdateUserEvent extends AuthEvent {
  final UserModel user;
  final String? profilePicture;
  final String? firstName;
  final String? lastName;
  final String? email;

  UpdateUserEvent(this.user,
      {this.profilePicture, this.firstName, this.lastName, this.email});
}

class VerifyUserEvent extends AuthEvent {
  final String email;
  final String code;

  VerifyUserEvent({required this.email, required this.code});
}

class CompleteOnboardingEvent extends AuthEvent {}

class FetchAllUsersEvent extends AuthEvent {}

class DeleteAccountEvent extends AuthEvent {}

class ResendCodeEvent extends AuthEvent {
  final String email;

  ResendCodeEvent({required this.email});
}

class ChangePasswordEvent extends AuthEvent {
  final String oldPassword;
  final String newPassword;
  final String confirmPassword;

  ChangePasswordEvent(
    this.oldPassword,
    this.newPassword,
    this.confirmPassword,
  );

  @override
  List<Object> get props => [oldPassword, newPassword, confirmPassword];
}
