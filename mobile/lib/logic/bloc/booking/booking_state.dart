import 'package:equatable/equatable.dart';
import 'package:hotel_flutter/data/model/booking/booking_model.dart';

abstract class BookingState extends Equatable {
  const BookingState();

  @override
  List<Object> get props => [];
}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class BookingSuccess extends BookingState {
  final List<BookingModel> bookings;

  const BookingSuccess({required this.bookings});

  @override
  List<Object> get props => [bookings];
}

class BookingCreateSuccess extends BookingState {
  final BookingModel booking;

  const BookingCreateSuccess({required this.booking});

  @override
  List<Object> get props => [booking];
}

class BookingUpdateSuccess extends BookingState {}

class BookingDeleteSuccess extends BookingState {}

class BookingFailure extends BookingState {
  final String error;

  const BookingFailure({required this.error});

  @override
  List<Object> get props => [error];
}
