class UserModel {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? token;
  final String? profilePicture;
  final bool? verified;
  final String? roles;
  bool? hasCompletedOnboarding;

  UserModel({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.token,
    this.profilePicture,
    this.verified,
    this.roles,
    this.hasCompletedOnboarding,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      token: json['token'],
      profilePicture: json['profile'],
      verified: json['verified'],
      roles: json['roles'],
      hasCompletedOnboarding: json['hasCompletedOnboarding'],
    );
  }
}
