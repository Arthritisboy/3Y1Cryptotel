import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hotel_flutter/data/model/auth/user_model.dart';
import 'package:hotel_flutter/data/model/auth/signup_model.dart';
import 'package:logging/logging.dart';

class AuthDataProvider {
  final Logger _logger = Logger('AuthDataProvider');
  final String _baseUrl = 'https://3-y1-cryptotel-hazel.vercel.app/api/v1';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  //! Helper: Get Token from Storage
  Future<String?> _getToken() async {
    return await _storage.read(key: 'jwt');
  }

  //! Helper: Handle HTTP Responses
  Future<Map<String, dynamic>> _handleResponse(http.Response response) async {
    final responseData = json.decode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return responseData;
    } else {
      final errorMessage = responseData['message'] ?? 'An error occurred';
      _logger.severe('Error: $errorMessage');
      throw Exception(errorMessage);
    }
  }

  //! Login
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );
    final data = await _handleResponse(response);

    await _storeAuthData(data);
    return data;
  }

  //! Store Auth Data
  Future<void> _storeAuthData(Map<String, dynamic> data) async {
    await _storage.write(key: 'jwt', value: data['token']);
    await _storage.write(key: 'userId', value: data['userId']);
    if (data['handleId'] != null) {
      await _storage.write(key: 'handleId', value: data['handleId']);
    }
  }

  //! Register
  Future<Map<String, dynamic>> register(SignUpModel model, File? image) async {
    final request =
        http.MultipartRequest('POST', Uri.parse('$_baseUrl/auth/signup'))
          ..headers['Content-Type'] = 'application/json'
          ..fields.addAll(model.toJson());

    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
    }

    final response = await request.send();
    return await _handleResponse(await http.Response.fromStream(response));
  }

  //! Verify User Code
  Future<void> verifyUser(String email, String code) async {
    await _post('$_baseUrl/auth/verifyCode', {'email': email, 'code': code});
  }

  //! Forgot Password
  Future<void> forgotPassword(String email) async {
    await _post('$_baseUrl/auth/forgotPassword', {'email': email});
  }

  //! Reset Password
  Future<void> resetPassword(
      String token, String newPassword, String confirmPassword) async {
    await _patch('$_baseUrl/auth/resetPassword/$token', {
      'password': newPassword,
      'confirmPassword': confirmPassword,
    });
  }

  //! Fetch User Data
  Future<UserModel> getUser(String userId) async {
    final response = await _get('$_baseUrl/users/$userId');
    return UserModel.fromJson(response['data']['user']);
  }

  //! Fetch All Users
  Future<List<UserModel>> fetchAllUsers() async {
    final response = await _get('$_baseUrl/users');
    final users = response['data']['users'] as List;
    return users.map((user) => UserModel.fromJson(user)).toList();
  }

  //! Delete Account
  Future<void> deleteAccount() async {
    await _delete('$_baseUrl/users/deleteMe');
    await _storage.deleteAll();
  }

  //! Update User Profile Data
  Future<UserModel> updateUserData({
    String? firstName,
    String? lastName,
    String? email,
    File? profilePicture,
  }) async {
    final request =
        http.MultipartRequest('PUT', Uri.parse('$_baseUrl/users/updateMe'))
          ..headers['Authorization'] = 'Bearer ${await _getToken()}';

    if (firstName != null) request.fields['firstName'] = firstName;
    if (lastName != null) request.fields['lastName'] = lastName;
    if (email != null) request.fields['email'] = email;
    if (profilePicture != null) {
      request.files
          .add(await http.MultipartFile.fromPath('image', profilePicture.path));
    }

    try {
      final response = await request.send();
      final responseData = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        // Parse the response body to extract user data
        final Map<String, dynamic> data = jsonDecode(responseData.body);
        final updatedUser = UserModel.fromJson(
            data['data']['user']); // Assuming you have a fromJson method

        // Log or print the new profile image URL
        _logger
            .info('Updated profile image URL: ${updatedUser.profilePicture}');

        return updatedUser; // Return the updated user model, including profile picture
      } else {
        throw Exception('Failed to update user data: ${responseData.body}');
      }
    } catch (error) {
      throw Exception('An error occurred during the update');
    }
  }

//!
  Future<void> logout() async {
    await _post('$_baseUrl/auth/logout');
    await _storage.deleteAll();
  }

  //! Helper: Perform HTTP GET
  Future<Map<String, dynamic>> _get(String url) async {
    final token = await _getToken();
    final response =
        await http.get(Uri.parse(url), headers: _buildHeaders(token));
    return await _handleResponse(response);
  }

  //! Helper: Perform HTTP POST
  Future<void> _post(String url, [Map<String, dynamic>? body]) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse(url),
      headers: _buildHeaders(token),
      body: body != null ? json.encode(body) : null,
    );
    await _handleResponse(response);
  }

  //! Helper: Perform HTTP PATCH
  Future<void> _patch(String url, Map<String, dynamic> body) async {
    final token = await _getToken();
    final response = await http.patch(
      Uri.parse(url),
      headers: _buildHeaders(token),
      body: json.encode(body),
    );
    await _handleResponse(response);
  }

  //! Helper: Perform HTTP PUT
  Future<void> _put(String url) async {
    final token = await _getToken();
    final response =
        await http.put(Uri.parse(url), headers: _buildHeaders(token));
    await _handleResponse(response);
  }

  //! Helper: Perform HTTP DELETE
  Future<void> _delete(String url) async {
    final token = await _getToken();
    final response =
        await http.delete(Uri.parse(url), headers: _buildHeaders(token));
    await _handleResponse(response);
  }

  //! Helper: Build HTTP Headers
  Map<String, String> _buildHeaders(String? token) {
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  //! Update User Onboarding
  Future<void> completeOnboarding() async {
    final token = await _storage.read(key: 'jwt');
    final response = await http.put(
      Uri.parse(
          'https://3-y1-cryptotel-hazel.vercel.app/api/v1/users/updateHasCompletedOnboarding'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode != 200) {
      final errorResponse = json.decode(response.body);
      String errorMessage = errorResponse['message'] ?? 'An error occurred';
      throw Exception('Failed to complete onboarding: $errorMessage');
    }
  }
}
