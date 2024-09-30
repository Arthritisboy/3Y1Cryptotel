import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hotel_flutter/data/model/signup_model.dart';

class AuthDataProvider {
  final String baseUrl = 'https://3-y1-cryptotel.vercel.app/api/v1/auth';

  Future<Map<String, dynamic>> login(String email, String password) async {
    print('Calling login method...');
    print('Attempting to log in with URL: $baseUrl/login');

    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      body: json.encode({
        'email': email,
        'password': password,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> register(SignUpModel signUpModel) async {
    final response = await http.post(
      Uri.parse('$baseUrl/signup'),
      body: json.encode(signUpModel.toJson()),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      final errorResponse = json.decode(response.body);
      String errorMessage = errorResponse['message'] ?? 'An error occurred';
      throw Exception('Failed to register: $errorMessage');
    }
  }
}
