class LoginModel {
  final String id; // Add this field
  final bool hasCompletedOnboarding; // Add this field

  LoginModel({required this.id, required this.hasCompletedOnboarding});

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      id: json['id'] ?? '', // Make sure to map the ID correctly
      hasCompletedOnboarding:
          json['hasCompletedOnboarding'] ?? false, // Ensure this is being set
    );
  }
}
