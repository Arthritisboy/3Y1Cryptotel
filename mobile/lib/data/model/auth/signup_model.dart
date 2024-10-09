class SignUpModel {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String confirmPassword;
  final String phoneNumber;
  final String gender;
  final String? profilePicture;

  SignUpModel({
    required this.phoneNumber,
    required this.gender,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.confirmPassword,
    this.profilePicture, // Nullable field
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'phoneNumber': phoneNumber,
      'gender': gender,
      'confirmPassword': confirmPassword,
      'profilePicture': profilePicture ?? '', // Optional field
    };
  }
}
