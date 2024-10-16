import 'dart:io';
import 'package:hotel_flutter/data/data_provider/auth/auth_data_provider.dart';
import 'package:hotel_flutter/data/model/auth/login_model.dart';
import 'package:hotel_flutter/data/model/auth/signup_model.dart';
import 'package:hotel_flutter/data/model/auth/user_model.dart';
import 'package:logging/logging.dart';

class AuthRepository {
  final Logger _logger = Logger('AuthRepository');
  final AuthDataProvider dataProvider;
  UserModel? _cachedUser;

  AuthRepository(this.dataProvider);

  //! Register
  Future<UserModel> register(
      SignUpModel signUpModel, File? profilePicture) async {
    try {
      final data = await dataProvider.register(signUpModel, profilePicture);
      return UserModel.fromJson(data);
    } catch (e) {
      throw Exception('Failed to register: ${e.toString()}');
    }
  }

  //! Login
  Future<LoginModel> login(String email, String password) async {
    try {
      final data = await dataProvider.login(email, password);
      return LoginModel.fromJson(data);
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  //! Forgot Password
  Future<void> forgotPassword(String email) async {
    try {
      await dataProvider.forgotPassword(email);
    } catch (e) {
      throw Exception(
          'Did not find any email or an error occurred. Please try again.');
    }
  }

  //! Reset Password
  Future<void> resetPassword(
      String token, String newPassword, String confirmPassword) async {
    return await dataProvider.resetPassword(
        token, newPassword, confirmPassword);
  }

  //! Get user
  Future<UserModel> getUser(String userId) async {
    if (_cachedUser != null) {
      return _cachedUser!;
    }

    try {
      // Directly fetch the UserModel from the data provider
      final user = await dataProvider.getUser(userId);

      // Cache the user
      _cachedUser = user;
      return _cachedUser!;
    } catch (error) {
      throw Exception('Failed to fetch user: $error');
    }
  }

//! Fetch all users with filtering conditions
  Future<List<UserModel>> fetchAllUsers() async {
    try {
      // Fetch users data from the data provider
      final usersData = await dataProvider.fetchAllUsers();

      // Check if usersData is a List<UserModel>
      if (usersData == null || usersData.isEmpty) {
        throw Exception('No users data found');
      }

      // Log the fetched users
      final filteredUsers = usersData.where((user) {
        return (user.active == true ||
                user.active == null) && // Include users with null active
            user.verified == true && // Ensure user is verified
            user.hasCompletedOnboarding ==
                true && // Ensure onboarding is complete
            user.roles == "user"; // Check for user role
      }).toList();

      // Log the filtered users count
      print('Filtered users count: ${filteredUsers.length}');

      return filteredUsers; // Return the filtered users
    } catch (error) {
      print('Failed to fetch all users: $error'); // Log error
      throw Exception('Failed to fetch all users: $error');
    }
  }

  // //! Update Password
  // Future<void> updatePassword(String currentPassword, String newPassword,
  //     String confirmPassword) async {
  //   final response = await dataProvider.updatePassword(
  //       currentPassword, newPassword, confirmPassword);
  //   return response;
  // }

  //! Logout
  Future<void> logout() async {
    try {
      await dataProvider.logout();
      clearUserCache(); // Clear cache on logout if necessary
    } catch (e) {
      throw Exception('Failed to logout: $e');
    }
  }

  //! Verify User
  Future<void> verifyUser(String email, String code) async {
    try {
      await dataProvider.verifyUser(email, code);
    } catch (e) {
      throw Exception('Verification failed: ${e.toString()}');
    }
  }

  //! Update User
  Future<UserModel> updateUser(
    UserModel user, {
    String? firstName,
    String? lastName,
    String? email,
    File? profilePicture,
  }) async {
    try {
      final updatedUser = await dataProvider.updateUserData(
        firstName: firstName ?? user.firstName,
        lastName: lastName ?? user.lastName,
        email: email ?? user.email,
        profilePicture: profilePicture,
      );
      return updatedUser; // Return the updated UserModel
    } catch (error) {
      throw Exception('Failed to update user: $error');
    }
  }

  //! Delete Account
  Future<void> deleteAccount() async {
    try {
      await dataProvider
          .deleteAccount(); // Call data provider to delete account
      clearUserCache(); // Clear the cached user data
      _logger.info('Account deleted successfully');
    } catch (e) {
      _logger.severe('Failed to delete account: $e'); // Log error
      throw Exception('Failed to delete account: ${e.toString()}');
    }
  }

  //! Check Onboarding Status
  Future<bool> checkOnboardingStatus(String userId) async {
    try {
      final user = await getUser(userId);
      return user.hasCompletedOnboarding ?? false;
    } catch (e) {
      return false; // Default to false on error
    }
  }

  //! Complete Onboarding
  Future<void> completeOnboarding() async {
    try {
      await dataProvider.completeOnboarding();
      _cachedUser?.hasCompletedOnboarding =
          true; // Update the cached user status
    } catch (e) {
      throw Exception('Failed to complete onboarding: ${e.toString()}');
    }
  }

  //! Clearing Cache
  void clearUserCache() {
    _cachedUser = null;
  }
}
