import 'package:equatable/equatable.dart';
import 'package:hotel_flutter/data/model/hotel/hotel_model.dart';

abstract class HotelState extends Equatable {
  const HotelState();

  @override
  List<Object?> get props => [];
}

class HotelInitial extends HotelState {}

class HotelLoading extends HotelState {}

class HotelLoaded extends HotelState {
  final List<HotelModel> hotels;

  const HotelLoaded(this.hotels);

  @override
  List<Object?> get props => [hotels];
}

class HotelDetailsLoaded extends HotelState {
  final HotelModel hotel;

  const HotelDetailsLoaded(this.hotel);

  @override
  List<Object?> get props => [hotel];
}

class HotelError extends HotelState {
  final String error;

  const HotelError(this.error);

  @override
  List<Object?> get props => [error];
}
