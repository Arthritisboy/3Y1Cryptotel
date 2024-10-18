import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:hotel_flutter/data/model/booking/booking_model.dart';

class BookingDataProvider {
  final String baseUrl =
      'https://3-y1-cryptotel-hazel.vercel.app/api/v1/bookings';
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  //! Fetch All Bookings
  Future<List<BookingModel>> fetchBookings(String userId) async {
    final token = await storage.read(key: 'jwt');

    if (token == null) {
      throw Exception('Authorization token is missing');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> bookingsJson =
          jsonDecode(response.body)['data']['bookings'];
      print('Bookings fetched: $bookingsJson');
      return bookingsJson.map((json) => BookingModel.fromJson(json)).toList();
    } else {
      final errorResponse = json.decode(response.body);
      String errorMessage =
          errorResponse['message'] ?? 'Failed to load bookings';
      throw Exception(errorMessage);
    }
  }

  //! Create a Booking
  Future<BookingModel> createBooking(
      BookingModel booking, String userId) async {
    final token = await storage.read(key: 'jwt');

    if (token == null) {
      throw Exception('Authorization token is missing');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(booking.toJson()),
    );

    if (response.statusCode == 201) {
      return BookingModel.fromJson(
          jsonDecode(response.body)['data']['booking']);
    } else {
      final errorResponse = json.decode(response.body);
      String errorMessage =
          errorResponse['message'] ?? 'Failed to create booking';
      throw Exception(errorMessage);
    }
  }

  //! Update a Booking with all fields
  Future<void> updateBooking(BookingModel booking, String bookingId) async {
    final token = await storage.read(key: 'jwt');

    if (token == null) {
      throw Exception('Authorization token is missing');
    }

    final response = await http.patch(
      Uri.parse('$baseUrl/$bookingId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(booking.toJson()), // Use toJson() to send all fields
    );

    if (response.statusCode != 200) {
      final errorResponse = json.decode(response.body);
      String errorMessage =
          errorResponse['message'] ?? 'Failed to update booking';
      throw Exception(errorMessage);
    }
  }

//! Delete a Booking and update availability based on booking type
  Future<void> deleteBooking(String bookingId) async {
    final token = await storage.read(key: 'jwt');

    if (token == null) {
      throw Exception('Authorization token is missing');
    }

    final response = await http.delete(
      Uri.parse('$baseUrl/$bookingId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 204) {
      // Booking deleted successfully, no further action needed on success.
      print('Booking deleted successfully');
    } else if (response.statusCode == 404) {
      // Handle booking not found error
      throw Exception('Booking not found');
    } else {
      // Handle other errors
      final errorResponse = jsonDecode(response.body);
      final errorMessage =
          errorResponse['message'] ?? 'Failed to delete booking';
      throw Exception(errorMessage);
    }
  }
}
