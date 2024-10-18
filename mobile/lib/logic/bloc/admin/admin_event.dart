import 'package:equatable/equatable.dart';
import 'package:hotel_flutter/data/model/admin/admin_model.dart';
import 'package:hotel_flutter/data/model/hotel/create_room_model.dart';

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

abstract class RoomEvent extends Equatable {
  const RoomEvent();

  @override
  List<Object?> get props => [];
}

// Event for Creating a Room
class CreateRoomEvent extends AdminEvent {
  final CreateRoomModel roomModel;
  final String hotelId;

  const CreateRoomEvent({required this.roomModel, required this.hotelId});

  @override
  List<Object?> get props => [roomModel, hotelId];
}
