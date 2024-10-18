import 'package:equatable/equatable.dart';

abstract class AdminState extends Equatable {
  const AdminState();

  @override
  List<Object?> get props => [];
}

// Initial State
class AdminInitial extends AdminState {}

// Loading State
class AdminLoading extends AdminState {}

// Success State
class AdminSuccess extends AdminState {
  final String message;

  const AdminSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

// Failure State
class AdminFailure extends AdminState {
  final String error;

  const AdminFailure(this.error);

  @override
  List<Object?> get props => [error];
}

abstract class RoomState extends Equatable {
  const RoomState();

  @override
  List<Object?> get props => [];
}

// Initial State
class RoomInitial extends RoomState {}

// Loading State
class RoomLoading extends RoomState {}

// Success State
class RoomSuccess extends RoomState {
  final String message;

  const RoomSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

// Failure State
class RoomFailure extends RoomState {
  final String error;

  const RoomFailure(this.error);

  @override
  List<Object?> get props => [error];
}
