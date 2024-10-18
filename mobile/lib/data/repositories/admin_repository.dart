import 'package:hotel_flutter/data/data_provider/auth/admin_data_provider.dart';
import 'package:hotel_flutter/data/model/admin/admin_model.dart';

class AdminRepository {
  final AdminDataProvider adminDataProvider;

  AdminRepository({required this.adminDataProvider});

  // Create Hotel
  Future<Map<String, dynamic>> createHotel(AdminModel adminModel) async {
    try {
      return await adminDataProvider.createHotel(
        name: adminModel.name,
        location: adminModel.location,
        openingHours: adminModel.openingHours,
        walletAddress: adminModel.walletAddress,
        managerEmail: adminModel.managerEmail,
        managerFirstName: adminModel.managerFirstName,
        managerLastName: adminModel.managerLastName,
        managerPassword: adminModel.managerPassword,
        managerPhoneNumber: adminModel.managerPhoneNumber,
        managerGender: adminModel.managerGender,
        hotelImage: adminModel.image,
      );
    } catch (e) {
      print('Error in AdminRepository.createHotel: $e');
      rethrow;
    }
  }

  // Create Restaurant
  Future<Map<String, dynamic>> createRestaurant(AdminModel adminModel) async {
    try {
      return await adminDataProvider.createRestaurant(
        name: adminModel.name,
        location: adminModel.location,
        openingHours: adminModel.openingHours,
        walletAddress: adminModel.walletAddress,
        managerEmail: adminModel.managerEmail,
        managerFirstName: adminModel.managerFirstName,
        managerLastName: adminModel.managerLastName,
        managerPassword: adminModel.managerPassword,
        managerPhoneNumber: adminModel.managerPhoneNumber,
        managerGender: adminModel.managerGender,
        capacity: adminModel.capacity ?? 0,
        restaurantImage: adminModel.image,
      );
    } catch (e) {
      print('Error in AdminRepository.createRestaurant: $e');
      rethrow;
    }
  }
}
