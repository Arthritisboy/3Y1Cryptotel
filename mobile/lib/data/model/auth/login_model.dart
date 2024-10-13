class LoginModel {
  final String token;
  final String userId;
  final bool hasCompletedOnboarding;
  final String roles;

  LoginModel({
    required this.token,
    required this.userId,
    required this.hasCompletedOnboarding,
    required this.roles,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      token: json['token'],
      userId: json['userId'],
      hasCompletedOnboarding: json['hasCompletedOnboarding'] ?? false,
      roles: json['roles'],
    );
  }
}
