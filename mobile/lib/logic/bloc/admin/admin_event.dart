import 'package:equatable/equatable.dart';
import 'package:hotel_flutter/data/model/admin/admin_model.dart';

abstract class AdminEvent extends Equatable {
  const AdminEvent();

  @override
  List<Object?> get props => [];
}

// Event for Creating a Hotel
class CreateHotelEvent extends AdminEvent {
  final AdminModel adminModel;

  const CreateHotelEvent(this.adminModel);

  @override
  List<Object?> get props => [adminModel];
}

// Event for Creating a Restaurant
class CreateRestaurantEvent extends AdminEvent {
  final AdminModel adminModel;

  const CreateRestaurantEvent(this.adminModel);

  @override
  List<Object?> get props => [adminModel];
}
