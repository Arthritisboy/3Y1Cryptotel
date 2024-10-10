import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:hotel_flutter/data/model/auth/user_model.dart';

class UserStorageHelper {
  // Helper function to store users in SharedPreferences
  static Future<void> storeUsers(List<UserModel> users) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String usersJson = jsonEncode(users.map((user) => user.toJson()).toList());
    await prefs.setString('allUsers', usersJson);
  }

  // Helper function to get stored users from SharedPreferences
  static Future<List<UserModel>> getStoredUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? usersJson = prefs.getString('allUsers');
    if (usersJson != null) {
      List<dynamic> decodedUsers = jsonDecode(usersJson);
      return decodedUsers.map((user) => UserModel.fromJson(user)).toList();
    }
    return [];
  }
}
