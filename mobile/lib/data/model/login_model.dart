class LoginModel {
  final String? id;
  final String? token;
  final bool hasCompletedOnboarding;

  LoginModel({this.id, this.token, required this.hasCompletedOnboarding});

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      id: json['userId'],
      token: json['token'],
      hasCompletedOnboarding: json['hasCompletedOnboarding'] ?? false,
    );
  }
}
