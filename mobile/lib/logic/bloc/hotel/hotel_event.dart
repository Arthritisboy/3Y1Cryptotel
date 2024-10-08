import 'package:equatable/equatable.dart';

abstract class HotelEvent extends Equatable {
  const HotelEvent();

  @override
  List<Object?> get props => [];
}

class FetchHotelsEvent extends HotelEvent {}

class FetchHotelDetailsEvent extends HotelEvent {
  final String hotelId;

  const FetchHotelDetailsEvent(this.hotelId);

  @override
  List<Object?> get props => [hotelId];
}
