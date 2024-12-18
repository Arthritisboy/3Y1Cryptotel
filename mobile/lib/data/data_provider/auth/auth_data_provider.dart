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

    // Ensure the response structure is correct
    if (response['data'] == null || response['data']['user'] == null) {
      throw Exception('Error fetching data! Scroll down to refresh.');
    }

    return UserModel.fromJson(response['data']['user']);
  }

  //! Fetch All Users
  Future<List<UserModel>> fetchAllUsers() async {
    final response = await _get('$_baseUrl/users');

    // Ensure the response structure is correct
    if (response['data'] == null || response['data']['users'] == null) {
      throw Exception('Error fetching data! scroll down to refresh.');
    }

    // Ensure that users is a List and map to UserModel
    final List<UserModel> users =
        List<Map<String, dynamic>>.from(response['data']['users'])
            .map((user) => UserModel.fromJson(user))
            .toList();

    print('Check: Fetched users: ${users.length}'); // Log total users fetched
    return users;
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

  //! Logout
  Future<void> logout() async {
    await _post('$_baseUrl/auth/logout');
    await _storage.deleteAll();
  }

  //! Resend Verification Code
  Future<void> resendCode(String email) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/resendCode'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email}),
    );

    await _handleResponse(response);
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

  //! Change Password
  Future<void> changePassword(
    String currentPassword,
    String newPassword,
    String confirmPassword,
  ) async {
    final String? token = await _getToken();

    if (token == null) {
      throw Exception('User not authenticated. Please login again.');
    }

    final response = await http.patch(
      Uri.parse('$_baseUrl/auth/updateMyPassword'), // Correct URL
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Token sent here
      },
      body: json.encode({
        'passwordCurrent': currentPassword,
        'password': newPassword,
        'confirmPassword': confirmPassword,
      }),
    );

    if (response.statusCode == 200) {
      _logger.info('Password updated successfully');
    } else {
      final error =
          json.decode(response.body)['message'] ?? 'Password update failed';
      _logger.severe('Password update failed: $error');
      throw Exception(error);
    }
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

  Future<Map<String, List<String>>> getFavorites(String userId) async {
    try {
      final token = await _getToken(); // Get the token
      final response = await http.get(
        Uri.parse('$_baseUrl/favorites/$userId'),
        headers: _buildHeaders(token), // Pass the token in headers
      );

      // Log the response for debugging
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Check if 'data' contains a 'favorite' object
        if (data['data'] != null && data['data']['favorite'] != null) {
          // Ensure that 'favorite.restaurants' and 'favorite.hotels' are lists
          List<String> restaurantIds = [];
          List<String> hotelIds = [];

          if (data['data']['favorite']['restaurants'] is List) {
            restaurantIds =
                List<String>.from(data['data']['favorite']['restaurants']);
          }

          if (data['data']['favorite']['hotels'] is List) {
            hotelIds = List<String>.from(data['data']['favorite']['hotels']);
          }

          // Return a map with both lists
          return {
            'restaurants': restaurantIds,
            'hotels': hotelIds,
          };
        } else {
          throw Exception('Favorites data is missing');
        }
      } else {
        print('Failed to load favorites: ${response.body}');
        throw Exception(
            'Failed to load favorites. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching favorites: $e');
      throw Exception('Failed to load favorites: ${e.toString()}');
    }
  }

  Future<void> addToFavorites(String userId, String type, String id) async {
    try {
      final token = await _getToken(); // Get the token
      final response = await http.post(
        Uri.parse('$_baseUrl/favorites/add/$userId'),
        headers: _buildHeaders(token), // Pass the token in headers
        body: json.encode({'type': type, 'id': id}),
      );

      // Log the response for debugging
      if (response.statusCode != 200) {
        print('Failed to add to favorites: ${response.body}');
        throw Exception(
            'Failed to add to favorites. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error adding to favorites: $e');
      throw Exception('Failed to add to favorites: ${e.toString()}');
    }
  }

  Future<void> removeFromFavorites(
      String userId, String type, String id) async {
    try {
      final token = await _getToken(); // Get the token
      final response = await http.delete(
        Uri.parse('$_baseUrl/favorites/remove/$userId'),
        headers: _buildHeaders(token), // Pass the token in headers
        body: json.encode({'type': type, 'id': id}),
      );

      // Log the response for debugging
      if (response.statusCode != 200) {
        print('Failed to remove from favorites: ${response.body}');
        throw Exception(
            'Failed to remove from favorites. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error removing from favorites: $e');
      throw Exception('Failed to remove from favorites: ${e.toString()}');
    }
  }
}
