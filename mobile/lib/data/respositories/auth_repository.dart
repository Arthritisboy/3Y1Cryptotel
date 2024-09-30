import 'package:hotel_flutter/data/data_provider/auth/auth_data_provider.dart';
import 'package:hotel_flutter/data/model/signup_model.dart';
import 'package:hotel_flutter/data/model/user_model.dart';

class AuthRepository {
  final AuthDataProvider dataProvider;

  AuthRepository(this.dataProvider);

  Future<UserModel> register(SignUpModel signUpModel) async {
    final data = await dataProvider.register(signUpModel);
    return UserModel.fromJson(data);
  }

  Future<UserModel> login(String email, String password) async {
    try {
      final data = await dataProvider.login(email, password);
      return UserModel.fromJson(data);
    } catch (e) {
      // Rethrow the error with a custom message or handle it as needed
      throw Exception('Incorrect email or password. Please try again!');
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      // Attempt to send the forgot password request
      await dataProvider.forgotPassword(email);
    } catch (e) {
      // Catch the exception and throw a user-friendly error message
      throw Exception(
          'Did not find any email or an error occurred. Please try again.'); // Make sure to use Exception
    }
  }

  Future<void> resetPassword(
      String token, String newPassword, String confirmPassword) async {
    return await dataProvider.resetPassword(
        token, newPassword, confirmPassword);
  }

  Future<void> logout() async {
    // Implement logout logic if needed
  }
}
