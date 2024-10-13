import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:hotel_flutter/data/model/favorite/favorite_model.dart';

class FavoriteDataProvider {
  final storage = const FlutterSecureStorage();

  Future<FavoriteModel> getFavorites(String userId) async {
    final token = await storage.read(key: 'jwt');
    final url =
        'https://3-y1-cryptotel-hazel.vercel.app/api/v1/favorites/$userId';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      // Ensure you access the correct path in the response
      // Adjust according to your actual response structure
      if (jsonResponse['data'] != null &&
          jsonResponse['data']['favorite'] != null) {
        return FavoriteModel.fromJson(jsonResponse['data']['favorite']);
      } else {
        throw Exception('Favorite data not found in the response');
      }
    } else {
      final errorResponse = json.decode(response.body);
      String errorMessage =
          errorResponse['message'] ?? 'Failed to fetch favorites';
      throw Exception(errorMessage);
    }
  }
}
