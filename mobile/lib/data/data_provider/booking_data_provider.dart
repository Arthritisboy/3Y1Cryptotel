import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hotel_flutter/data/model/booking/booking_model.dart';
import 'package:http/http.dart' as http;

class BookingDataProvider {
  final String baseUrl;
  final http.Client httpClient;
  final FlutterSecureStorage storage =
      const FlutterSecureStorage(); // Use secure storage to get token

  BookingDataProvider({required this.baseUrl, required this.httpClient});

  //! Fetch All Bookings
  Future<List<BookingModel>> fetchBookings(String userId) async {
    final token =
        await storage.read(key: 'jwt'); // Retrieve token from secure storage

    if (token == null) {
      throw Exception('Authorization token is missing');
    }

    final response = await httpClient.get(
      Uri.parse('$baseUrl/bookings/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer $token', // Pass the token in the Authorization header
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> bookingsJson =
          jsonDecode(response.body)['data']['bookings'];
      return bookingsJson.map((json) => BookingModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load bookings: ${response.body}');
    }
  }

  //! Create a Booking
  Future<BookingModel> createBooking(
      BookingModel booking, String userId) async {
    final token =
        await storage.read(key: 'jwt'); // Retrieve token from secure storage

    if (token == null) {
      throw Exception('Authorization token is missing');
    }

    final response = await httpClient.post(
      Uri.parse('$baseUrl/bookings/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer $token', // Pass the token in the Authorization header
      },
      body: jsonEncode(booking.toJson()),
    );

    if (response.statusCode == 201) {
      return BookingModel.fromJson(
          jsonDecode(response.body)['data']['booking']);
    } else {
      throw Exception('Failed to create booking: ${response.body}');
    }
  }

  //! Update a Booking
  Future<void> updateBooking(BookingModel booking, String bookingId) async {
    final token =
        await storage.read(key: 'jwt'); // Retrieve token from secure storage

    if (token == null) {
      throw Exception('Authorization token is missing');
    }

    final response = await httpClient.patch(
      Uri.parse('$baseUrl/bookings/$bookingId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer $token', // Pass the token in the Authorization header
      },
      body: jsonEncode(booking.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update booking: ${response.body}');
    }
  }

  //! Delete a Booking
  Future<void> deleteBooking(String bookingId) async {
    final token =
        await storage.read(key: 'jwt'); // Retrieve token from secure storage

    if (token == null) {
      throw Exception('Authorization token is missing');
    }

    final response = await httpClient.delete(
      Uri.parse('$baseUrl/bookings/$bookingId'),
      headers: {
        'Authorization':
            'Bearer $token', // Pass the token in the Authorization header
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete booking: ${response.body}');
    }
  }
}
