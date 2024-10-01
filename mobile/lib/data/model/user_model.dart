class UserModel {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? email;

  UserModel({this.id, this.firstName, this.lastName, this.email});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
    );
  }
}
