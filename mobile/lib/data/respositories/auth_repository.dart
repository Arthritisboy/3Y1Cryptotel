import 'package:hotel_flutter/data/data_provider/auth/auth_dataprovider.dart';
import 'package:hotel_flutter/data/model/user_model.dart';
import 'package:hotel_flutter/data/model/signup_model.dart';

class AuthRepository {
  final AuthDataProvider dataProvider;

  AuthRepository(this.dataProvider);

  Future<UserModel> register(SignUpModel signUpModel) async {
    final data = await dataProvider.register(signUpModel);
    return UserModel.fromJson(data);
  }

  Future<UserModel> login(String email, String password) async {
    final data = await dataProvider.login(email, password);
    return UserModel.fromJson(data);
  }

  Future<void> logout() async {
    // Implement logout logic if needed
  }
}
