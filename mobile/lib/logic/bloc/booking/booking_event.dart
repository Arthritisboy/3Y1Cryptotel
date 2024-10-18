import 'package:equatable/equatable.dart';
import 'package:hotel_flutter/data/model/booking/booking_model.dart';

abstract class BookingEvent extends Equatable {
  const BookingEvent();

  @override
  List<Object> get props => [];
}

class FetchBookings extends BookingEvent {
  final String userId;

  const FetchBookings({required this.userId});

  @override
  List<Object> get props => [userId];
}

class CreateBooking extends BookingEvent {
  final BookingModel booking;
  final String userId;

  const CreateBooking({required this.booking, required this.userId});

  @override
  List<Object> get props => [booking, userId];
}

class UpdateBooking extends BookingEvent {
  final BookingModel booking;
  final String bookingId;
  final String userId; // Add the userId here to fetch updated bookings.

  const UpdateBooking({
    required this.booking,
    required this.bookingId,
    required this.userId,
  });
}

class DeleteBooking extends BookingEvent {
  final String bookingId;
  final String userId; // Add userId here

  DeleteBooking(this.bookingId, this.userId);
}
