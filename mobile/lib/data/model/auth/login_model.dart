class LoginModel {
  final String id;
  final bool hasCompletedOnboarding;
  final String roles;

  LoginModel(
      {required this.id,
      required this.hasCompletedOnboarding,
      required this.roles});

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
        id: json['userId'] ?? '',
        hasCompletedOnboarding: json['hasCompletedOnboarding'] ?? false,
        roles: json['roles']);
  }
}
