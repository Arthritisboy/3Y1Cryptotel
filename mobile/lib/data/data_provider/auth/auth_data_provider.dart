import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hotel_flutter/data/model/signup_model.dart';

class AuthDataProvider {
  final String baseUrl = 'https://3-y1-cryptotel.vercel.app/api/v1/auth';

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      body: json.encode({
        'email': email,
        'password': password,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // If login is successful, return the user data
      return json.decode(response.body);
    } else {
      // If login fails, parse the response for an error message
      final errorResponse = json.decode(response.body);
      String errorMessage =
          errorResponse['message'] ?? 'Login failed. Please try again.';
      throw Exception(errorMessage); // Throw a more descriptive exception
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

  Future<void> forgotPassword(String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/forgotPassword'),
      body: json.encode({'email': email}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      final errorResponse = json.decode(response.body);
      String errorMessage = errorResponse['message'] ?? 'An error occurred';
      throw Exception('Failed to send reset link: $errorMessage');
    }
  }

  Future<void> resetPassword(
      String token, String newPassword, String confirmPassword) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/resetPassword/$token'),
      body: json.encode({
        'password': newPassword,
        'confirmPassword': confirmPassword, // Include confirmPassword here
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      final errorResponse = json.decode(response.body);
      String errorMessage = errorResponse['message'] ?? 'An error occurred';
      throw Exception('Failed to reset password: $errorMessage');
    }
  }
}
