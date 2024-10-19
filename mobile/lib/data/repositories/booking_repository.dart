import 'package:hotel_flutter/data/data_provider/auth/booking_data_provider.dart';
import 'package:hotel_flutter/data/model/booking/booking_model.dart';

class BookingRepository {
  final BookingDataProvider dataProvider;
  List<BookingModel>? _cachedBookings;

  BookingRepository(this.dataProvider);

  //! Fetch All Bookings with Cache
  Future<List<BookingModel>> fetchBookings(String userId) async {
    if (_cachedBookings != null) {
      return _cachedBookings!;
    }
    try {
      final bookings = await dataProvider.fetchBookings(userId);
      _cachedBookings = bookings;
      return bookings;
    } catch (e) {
      throw Exception('Failed to load bookings: $e');
    }
  }

  //! Create a Booking (Clear cache after creation)
  Future<BookingModel> createBooking(
      BookingModel booking, String userId) async {
    try {
      final newBooking = await dataProvider.createBooking(booking, userId);
      _cachedBookings = null; // Clear cache after booking creation
      return newBooking;
    } catch (e) {
      throw Exception('Failed to create booking: $e');
    }
  }

  //! Update a Booking (Clear cache after update)
  Future<void> updateBooking(BookingModel booking, String bookingId) async {
    try {
      await dataProvider.updateBooking(booking, bookingId);
      _cachedBookings = null; // Clear cache after booking update
    } catch (e) {
      throw Exception('Failed to update booking: $e');
    }
  }

  //! Delete a Booking (Clear cache after deletion)
  Future<void> deleteBooking(String bookingId) async {
    try {
      await dataProvider.deleteBooking(bookingId);
      _cachedBookings = null; // Clear cache after booking deletion
    } catch (e) {
      throw Exception('Failed to delete booking: $e');
    }
  }

  //! Clear Booking Cache
  void clearBookingCache() {
    _cachedBookings = null;
  }
}