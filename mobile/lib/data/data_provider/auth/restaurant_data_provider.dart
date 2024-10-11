import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hotel_flutter/data/model/restaurant/restaurant_model.dart';

class RestaurantDataProvider {
  final String baseUrl = 'https://3-y1-cryptotel.vercel.app/api/v1/restaurant';
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  //! Fetch All Restaurants
  Future<List<RestaurantModel>> fetchRestaurants() async {
    final token = await storage.read(key: 'jwt');

    if (token == null) {
      throw Exception('Authorization token is missing');
    }

    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data']['restaurant'] as List;
      return data
          .map((restaurantJson) => RestaurantModel.fromJson(restaurantJson))
          .toList();
    } else {
      throw Exception('Failed to load restaurants: ${response.body}');
    }
  }

  //! Fetch Single Restaurant by ID
  Future<RestaurantModel> fetchRestaurantById(String restaurantId) async {
    final String url = '$baseUrl/$restaurantId';
    final token = await storage.read(key: 'jwt');

    if (token == null) {
      throw Exception('Authorization token is missing');
    }

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data']['restaurant'];
      return RestaurantModel.fromJson(data);
    } else {
      throw Exception('Failed to load restaurant: ${response.body}');
    }
  }
}
