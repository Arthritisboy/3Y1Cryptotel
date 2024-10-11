import 'package:equatable/equatable.dart';
import 'package:hotel_flutter/data/model/booking/booking_model.dart';

abstract class BookingEvent extends Equatable {
  const BookingEvent();

  @override
  List<Object> get props => [];
}

class FetchBookings extends BookingEvent {
  final String userId;

  FetchBookings(this.userId);

  @override
  List<Object> get props => [userId];
}

class CreateBooking extends BookingEvent {
  final BookingModel booking;
  final String userId;

  CreateBooking({required this.booking, required this.userId});

  @override
  List<Object> get props => [booking, userId];
}

class UpdateBooking extends BookingEvent {
  final BookingModel booking;
  final String bookingId;

  UpdateBooking({required this.booking, required this.bookingId});

  @override
  List<Object> get props => [booking, bookingId];
}

class DeleteBooking extends BookingEvent {
  final String bookingId;

  DeleteBooking(this.bookingId);

  @override
  List<Object> get props => [bookingId];
}