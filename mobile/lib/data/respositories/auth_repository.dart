import 'package:hotel_flutter/data/data_provider/auth_provider.dart';
import 'package:hotel_flutter/data/model/user_model.dart';

class AuthRepository {
  final AuthDataProvider dataProvider;

  AuthRepository(this.dataProvider);

  Future<UserModel> register(String email, String password) async {
    final data = await dataProvider.register(email, password);
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
