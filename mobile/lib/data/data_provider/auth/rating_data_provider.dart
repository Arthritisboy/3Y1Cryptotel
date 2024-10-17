import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hotel_flutter/data/model/rating/hotel_and_restaurant_rating.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RatingDataProvider {
  final String baseUrl = 'https://3-y1-cryptotel-hazel.vercel.app/api/v1';
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  //! Create a new rating for a room
  Future<HotelAndRestaurantRating> createRoomRating({
    required String roomId,
    required int rating,
    required String message,
  }) async {
    final String url = '$baseUrl/rooms/$roomId/ratings';

    // Read the JWT token from secure storage
    final token = await storage.read(key: 'jwt');

    // Check if the token exists
    if (token == null) {
      throw Exception('Authorization token is missing');
    }

    try {
      // Make an authenticated POST request to create a rating for a room
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Add the token in the Authorization header
        },
        body: json.encode({
          'rating': rating,
          'message': message,
        }),
      );

      // Handle response and status code
      if (response.statusCode == 201) {
        final ratingJson = json.decode(response.body)['data']['rating'];
        return HotelAndRestaurantRating.fromJson(ratingJson); // Return the created rating
      } else {
        throw Exception('Failed to create room rating: ${response.body}');
      }
    } catch (error) {
      print('Error creating room rating: $error');
      throw error;
    }
  }

  //! Create a new rating for a restaurant
  Future<HotelAndRestaurantRating> createRestaurantRating({
    required String restaurantId,
    required int rating,
    required String message,
  }) async {
    final String url = '$baseUrl/restaurants/$restaurantId/ratings';

    // Read the JWT token from secure storage
    final token = await storage.read(key: 'jwt');

    // Check if the token exists
    if (token == null) {
      throw Exception('Authorization token is missing');
    }

    try {
      // Make an authenticated POST request to create a rating for a restaurant
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Add the token in the Authorization header
        },
        body: json.encode({
          'rating': rating,
          'message': message,
        }),
      );

      // Handle response and status code
      if (response.statusCode == 201) {
        final ratingJson = json.decode(response.body)['data']['rating'];
        return HotelAndRestaurantRating.fromJson(ratingJson); // Return the created rating
      } else {
        throw Exception('Failed to create restaurant rating: ${response.body}');
      }
    } catch (error) {
      print('Error creating restaurant rating: $error');
      throw error;
    }
  }
}
