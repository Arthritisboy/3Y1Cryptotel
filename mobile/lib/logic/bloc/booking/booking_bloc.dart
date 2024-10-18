import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotel_flutter/data/repositories/booking_repository.dart';
import 'package:hotel_flutter/logic/bloc/booking/booking_event.dart';
import 'package:hotel_flutter/logic/bloc/booking/booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final BookingRepository bookingRepository;

  BookingBloc(this.bookingRepository) : super(BookingInitial()) {
    on<FetchBookings>(_onFetchBookings);
    on<CreateBooking>(_onCreateBooking);
    on<UpdateBooking>(_onUpdateBooking);
    on<DeleteBooking>(_onDeleteBooking);
  }

  Future<void> _onFetchBookings(
      FetchBookings event, Emitter<BookingState> emit) async {
    emit(BookingLoading());
    try {
      final bookings = await bookingRepository.fetchBookings(event.userId);
      emit(BookingSuccess(bookings: bookings));
    } catch (e) {
      emit(BookingFailure(error: e.toString()));
    }
  }

  Future<void> _onCreateBooking(
      CreateBooking event, Emitter<BookingState> emit) async {
    emit(BookingLoading());
    try {
      final booking =
          await bookingRepository.createBooking(event.booking, event.userId);
      emit(BookingCreateSuccess(booking: booking));
    } catch (e) {
      emit(BookingFailure(error: e.toString()));
    }
  }

  Future<void> _onUpdateBooking(
      UpdateBooking event, Emitter<BookingState> emit) async {
    emit(BookingLoading());
    try {
      await bookingRepository.updateBooking(event.booking, event.bookingId);

      // Fetch updated bookings list after update
      final bookings = await bookingRepository.fetchBookings(event.userId);
      emit(BookingSuccess(bookings: bookings));
    } catch (e) {
      emit(BookingFailure(error: e.toString()));
    }
  }

  //! Delete Booking Handler
  Future<void> _onDeleteBooking(
      DeleteBooking event, Emitter<BookingState> emit) async {
    emit(BookingLoading());
    try {
      // Call the repository method with bookingId and bookingType
      await bookingRepository.deleteBooking(event.bookingId);
      emit(BookingDeleteSuccess());
    } catch (e) {
      emit(BookingFailure(error: e.toString()));
    }
  }
}
