class UserModel {
  final String? id;
  final String? token;

  UserModel({this.id, this.token});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['userId'],
      token: json['token'],
    );
  }
}
