class LoginModel {
  final String? id;
  final String? token;

  LoginModel({this.id, this.token});

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      id: json['id'],
      token: json['token'],
    );
  }
}
