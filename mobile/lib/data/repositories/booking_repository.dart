import 'package:hotel_flutter/data/data_provider/auth/booking_data_provider.dart';
import 'package:hotel_flutter/data/model/booking/booking_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class BookingRepository {
  final BookingDataProvider dataProvider;
  List<BookingModel>? _cachedBookings;

  BookingRepository(this.dataProvider);

  //! Fetch All Bookings with Cache
  Future<List<BookingModel>> fetchBookings(String userId) async {
    // Always fetch from the data provider and update the cache
    try {
      final bookings = await dataProvider.fetchBookings(userId);
      _cachedBookings = bookings; // Update cache
      await _saveBookingsToPrefs(bookings); // Save to preferences
      return bookings;
    } catch (e) {
      // If fetching from the data provider fails, try loading from SharedPreferences
      _cachedBookings = await _loadBookingsFromPrefs();
      if (_cachedBookings == null) {
        throw Exception('Failed to load bookings: $e');
      }
      return _cachedBookings!;
    }
  }

  Future<List<BookingModel>?> _loadBookingsFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('bookings');
    if (jsonString != null) {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((json) => BookingModel.fromJson(json)).toList();
    }
    return null; // Return null if no bookings are found
  }

  Future<void> _saveBookingsToPrefs(List<BookingModel> bookings) async {
    final prefs = await SharedPreferences.getInstance();
    // Convert bookings to JSON and save as a string
    final jsonString = jsonEncode(bookings.map((b) => b.toJson()).toList());
    await prefs.setString('bookings', jsonString);
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
