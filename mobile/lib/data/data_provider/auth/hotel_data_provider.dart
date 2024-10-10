import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hotel_flutter/data/model/hotel/hotel_model.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'dart:convert';

class HotelDataProvider {
  final String baseUrl = 'https://3-y1-cryptotel-hazel.vercel.app/api/v1/auth';

  final FlutterSecureStorage storage = const FlutterSecureStorage();

  //! Fetch Hotels
  Future<List<HotelModel>> fetchHotels() async {
    final String url = 'https://3-y1-cryptotel-hazel.vercel.app/api/v1/hotel';
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
      final data = json.decode(response.body)['data']['hotel'] as List;
      return data.map((hotelJson) => HotelModel.fromJson(hotelJson)).toList();
    } else {
      throw Exception('Failed to load hotels: ${response.body}');
    }
  }

//! Fetch Single Hotel by ID
  Future<HotelModel> fetchHotelById(String hotelId) async {
    final String url =
        'https://3-y1-cryptotel-hazel.vercel.app/api/v1/hotel/$hotelId';
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
      final data = json.decode(response.body)['data']['hotel'];
      return HotelModel.fromJson(data);
    } else {
      throw Exception('Failed to load hotel: ${response.body}');
    }
  }
}
