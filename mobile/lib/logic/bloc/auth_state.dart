import 'package:equatable/equatable.dart';
import 'package:hotel_flutter/data/model/login_model.dart';
import 'package:hotel_flutter/data/model/user_model.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthenticatedLogin extends AuthState {
  final LoginModel user;

  const AuthenticatedLogin(this.user);

  @override
  List<Object> get props => [user];
}

class Authenticated extends AuthState {
  final UserModel user;

  const Authenticated(this.user);

  @override
  List<Object> get props => [user];
}

class AuthError extends AuthState {
  final String error;

  const AuthError(this.error);

  @override
  List<Object> get props => [error];
}

class AuthSuccess extends AuthState {
  final String message;

  const AuthSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class AuthPasswordChangeSuccess extends AuthState {
  final String message;

  const AuthPasswordChangeSuccess(this.message);

  @override
  List<Object> get props => [message];
}
