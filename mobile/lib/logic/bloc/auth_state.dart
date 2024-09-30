import 'package:equatable/equatable.dart';
import 'package:hotel_flutter/data/model/user_model.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final UserModel user;

  Authenticated(this.user);

  @override
  List<Object> get props => [user];
}

class AuthError extends AuthState {
  final String error;

  AuthError(this.error);

  @override
  List<Object> get props => [error];
}
