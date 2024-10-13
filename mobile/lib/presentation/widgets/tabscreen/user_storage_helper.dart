import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hotel_flutter/data/model/auth/user_model.dart';

class UserStorageHelper {
  static const String _usersKey = 'storedUsers';

  /// Store a list of users in SharedPreferences
  static Future<void> storeUsers(List<UserModel> users) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> jsonUsers =
        users.map((user) => jsonEncode(user.toJson())).toList();
    await prefs.setStringList(_usersKey, jsonUsers);
  }

  /// Retrieve a list of users from SharedPreferences
  static Future<List<UserModel>> getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? jsonUsers = prefs.getStringList(_usersKey);
    if (jsonUsers != null) {
      return jsonUsers
          .map((jsonUser) => UserModel.fromJson(jsonDecode(jsonUser)))
          .toList();
    }
    return [];
  }

  /// Clear the stored users from SharedPreferences
  static Future<void> clearUsers() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_usersKey);
  }
}
