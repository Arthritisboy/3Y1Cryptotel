import 'dart:io';

class AdminModel {
  final String name;
  final String location;
  final String openingHours;
  final String walletAddress;
  final String managerEmail;
  final String managerFirstName;
  final String managerLastName;
  final String managerPassword;
  final String managerPhoneNumber;
  final String managerGender;
  final int? capacity; // Only for restaurants
  final File image;

  AdminModel({
    required this.name,
    required this.location,
    required this.openingHours,
    required this.walletAddress,
    required this.managerEmail,
    required this.managerFirstName,
    required this.managerLastName,
    required this.managerPassword,
    required this.managerPhoneNumber,
    required this.managerGender,
    this.capacity,
    required this.image,
  });

  // Convert AdminModel to a map for HTTP request (without image)
  Map<String, String> toMap() {
    final data = {
      'name': name,
      'location': location,
      'openingHours': openingHours,
      'walletAddress': walletAddress,
      'managerEmail': managerEmail,
      'managerFirstName': managerFirstName,
      'managerLastName': managerLastName,
      'managerPassword': managerPassword,
      'managerPhoneNumber': managerPhoneNumber,
      'managerGender': managerGender,
    };
    if (capacity != null) {
      data['capacity'] = capacity.toString();
    }
    return data;
  }
}
