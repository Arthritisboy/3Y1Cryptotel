class LoginModel {
  final String id;
  final bool hasCompletedOnboarding;

  LoginModel({required this.id, required this.hasCompletedOnboarding});

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      id: json['userId'] ?? '',
      hasCompletedOnboarding: json['hasCompletedOnboarding'] ?? false,
    );
  }
}
