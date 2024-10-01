import 'package:hotel_flutter/data/model/user_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hotel_flutter/data/model/signup_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthDataProvider {
  final String baseUrl = 'https://3-y1-cryptotel.vercel.app/api/v1/auth';
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  //! Login
  Future<Map<String, dynamic>> login(String email, String password) async {
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
      final data = json.decode(response.body);

      String token = data['token'];
      String userId = data['userId'];

      await storage.write(key: 'jwt', value: token);
      await storage.write(key: 'userId', value: userId);

      return {
        'token': token,
        'user': {
          'id': userId,
        },
      };
    } else {
      final errorResponse = json.decode(response.body);
      String errorMessage = errorResponse['message'] ?? response.reasonPhrase;
      throw Exception('Failed to login: $errorMessage');
    }
  }

  //! Register
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

  //! Forgot Password
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

  //! Reset Password
  Future<void> resetPassword(
      String token, String newPassword, String confirmPassword) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/resetPassword/$token'),
      body: json.encode({
        'password': newPassword,
        'confirmPassword': confirmPassword,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      final errorResponse = json.decode(response.body);
      String errorMessage = errorResponse['message'] ?? 'An error occurred';
      throw Exception('Failed to reset password: $errorMessage');
    }
  }

//! Fetch User
  Future<UserModel> getUser(String userId) async {
    final token = await storage.read(key: 'jwt');

    final url = 'https://3-y1-cryptotel.vercel.app/api/v1/users/$userId';
    print('Fetching user from URL: $url');
    print('Token: $token');

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
      return UserModel.fromJson(jsonResponse['data']['user']);
    } else {
      print(
          'Error response body: ${response.body}'); // Print the full error response
      final errorResponse = json.decode(response.body);
      String errorMessage =
          errorResponse['message'] ?? 'Failed to fetch user data';
      throw Exception(errorMessage);
    }
  }

  //! Logout
  Future<void> logout() async {
    // Clear the stored token and userId
    await storage.delete(key: 'jwt');
    await storage.delete(key: 'userId');
  }
}
