class SignUpModel {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String confirmPassword;
  final String phoneNumber;
  final String gender;
  final String roles; // Ensure this is never null
  final String? profilePicture;

  SignUpModel({
    required this.phoneNumber,
    required this.gender,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    this.roles = 'user', // Default to 'user' if not specified
    required this.confirmPassword,
    this.profilePicture,
  });

  Map<String, String> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'phoneNumber': phoneNumber,
      'gender': gender,
      'roles': roles, // This should never be null
      'confirmPassword': confirmPassword,
      'profilePicture': profilePicture ?? '',
    };
  }
}
