import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AdminDataProvider {
  final String _baseUrl = 'https://3-y1-cryptotel-hazel.vercel.app/api/v1';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Helper: Get Token from Secure Storage
  Future<String?> _getToken() async {
    return await _storage.read(key: 'jwt');
  }

  // Helper: Handle HTTP Response with Error Handling
  Future<Map<String, dynamic>> _handleResponse(http.Response response) async {
    final responseData = json.decode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return responseData;
    } else {
      final errorMessage = responseData['message'] ?? 'Request failed';
      print('Error: $errorMessage'); // Log error message
      throw Exception(errorMessage);
    }
  }

  // Helper: Build HTTP Headers with Authorization
  Map<String, String> _buildHeaders(String token) {
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  Future<Map<String, dynamic>> createHotel({
    required String name,
    required String location,
    required String openingHours,
    required String walletAddress,
    required String managerEmail,
    required String managerFirstName,
    required String managerLastName,
    required String managerPassword,
    required String managerConfirmPassword,
    required String managerPhoneNumber,
    required String managerGender,
    required File hotelImage,
    int? capacity, // Optional capacity field
    int? price, // Optional price field
  }) async {
    try {
      final String? token = await _getToken();
      if (token == null) {
        throw Exception('Authentication required. Please log in.');
      }

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$_baseUrl/hotel'),
      )
        ..headers['Authorization'] = 'Bearer $token'
        ..fields['name'] = name
        ..fields['location'] = location
        ..fields['openingHours'] = openingHours
        ..fields['walletAddress'] = walletAddress
        ..fields['managerEmail'] = managerEmail
        ..fields['managerFirstName'] = managerFirstName
        ..fields['managerLastName'] = managerLastName
        ..fields['managerPassword'] = managerPassword
        ..fields['managerConfirmPassword'] = managerConfirmPassword
        ..fields['managerPhoneNumber'] = managerPhoneNumber
        ..fields['managerGender'] = managerGender;

      // Add optional fields
      if (capacity != null) {
        request.fields['capacity'] = capacity.toString();
      }
      if (price != null) {
        request.fields['price'] = price.toString();
      }

      // Attach the image file
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        hotelImage.path,
      ));

      final response = await request.send();
      final httpResponse = await http.Response.fromStream(response);

      return await _handleResponse(httpResponse);
    } catch (e) {
      print('Error creating hotel: $e');
      rethrow;
    }
  }

  // Create Restaurant with Manager Registration and Image Upload
  Future<Map<String, dynamic>> createRestaurant({
    required String name,
    required String location,
    required String openingHours,
    required String walletAddress,
    required String managerEmail,
    required String managerFirstName,
    required String managerLastName,
    required String managerPassword,
    required String managerPhoneNumber,
    required String managerConfirmPassword,
    required String managerGender,
    required int capacity,
    required int price,
    required File restaurantImage,
  }) async {
    try {
      final String? token = await _getToken();
      if (token == null) {
        throw Exception('Authentication required. Please log in.');
      }

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$_baseUrl/restaurant'),
      )
        ..headers['Authorization'] = 'Bearer $token'
        ..fields['name'] = name
        ..fields['location'] = location
        ..fields['openingHours'] = openingHours
        ..fields['walletAddress'] = walletAddress
        ..fields['managerEmail'] = managerEmail
        ..fields['managerFirstName'] = managerFirstName
        ..fields['managerLastName'] = managerLastName
        ..fields['managerPassword'] = managerPassword
        ..fields['managerConfirmPassword'] = managerConfirmPassword
        ..fields['managerPhoneNumber'] = managerPhoneNumber
        ..fields['managerGender'] = managerGender
        ..fields['capacity'] = capacity.toString()
        ..fields['price'] = price.toString();

      // Attach the image file to the request
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        restaurantImage.path,
      ));

      // Send Request and Handle Response
      final response = await request.send();
      final httpResponse = await http.Response.fromStream(response);

      return await _handleResponse(httpResponse);
    } catch (e) {
      print('Error creating restaurant: $e'); // Log the error for debugging
      rethrow;
    }
  }
}
