import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hotel_flutter/data/model/auth/user_model.dart';

class UserStorageHelper {
  static const String _usersKey = 'storedUsers';

  static Future<void> storeUsers(List<UserModel> users) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> jsonUsers =
        users.map((user) => jsonEncode(user.toJson())).toList();
    await prefs.setStringList(_usersKey, jsonUsers);
  }

  static Future<List<UserModel>> getUsers() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? jsonUsers = prefs.getStringList(_usersKey);
    if (jsonUsers != null) {
      return jsonUsers
          .map((jsonUser) => UserModel.fromJson(jsonDecode(jsonUser)))
          .toList();
    }
    return [];
  }

  static Future<void> clearUsers() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs
        .remove(_usersKey); // This removes the key from SharedPreferences
  }
}
