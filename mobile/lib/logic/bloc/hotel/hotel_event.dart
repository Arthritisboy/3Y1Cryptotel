import 'package:equatable/equatable.dart';

abstract class HotelEvent extends Equatable {
  const HotelEvent();

  @override
  List<Object?> get props => [];
}

// Event: Fetch all hotels
class FetchHotelsEvent extends HotelEvent {}

// Event: Fetch single hotel details by ID
class FetchHotelDetailsEvent extends HotelEvent {
  final String hotelId;

  const FetchHotelDetailsEvent(this.hotelId);

  @override
  List<Object?> get props => [hotelId];
}

// Event: Search hotels by query
class SearchHotelsEvent extends HotelEvent {
  final String query;

  const SearchHotelsEvent(this.query);

  @override
  List<Object?> get props => [query];
}
