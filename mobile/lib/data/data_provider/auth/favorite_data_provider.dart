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

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      // Ensure we are accessing the correct path in the response
      return FavoriteModel.fromJson(jsonResponse['data']['favorite']);
    } else {
      final errorResponse = json.decode(response.body);
      String errorMessage =
          errorResponse['message'] ?? 'Failed to fetch favorites';
      throw Exception(errorMessage);
    }
  }
}
