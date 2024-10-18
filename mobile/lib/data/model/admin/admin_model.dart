import 'dart:io';

class AdminModel {
  final String name;
  final String location;
  final String openingHours;
  final String managerEmail;
  final String managerFirstName;
  final String managerLastName;
  final String managerPhoneNumber;
  final String managerGender;
  final String managerPassword;
  final String managerConfirmPassword;
  final String walletAddress;
  final File image;
  final int? capacity;
  final int? price; // Optional price field

  AdminModel({
    required this.name,
    required this.location,
    required this.openingHours,
    required this.walletAddress,
    required this.managerEmail,
    required this.managerFirstName,
    required this.managerLastName,
    required this.managerPassword,
    required this.managerConfirmPassword,
    required this.managerPhoneNumber,
    required this.managerGender,
    this.capacity,
    this.price,
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
      'managerPhoneNumber': managerPhoneNumber,
      'managerGender': managerGender,
      'managerPassword': managerPassword,
      'managerConfirmPassword': managerConfirmPassword,
    };

    // Add optional capacity if available
    if (capacity != null) {
      data['capacity'] = capacity.toString();
    }

    // Add optional price if available
    if (price != null) {
      data['price'] = price.toString();
    }

    return data;
  }
}
