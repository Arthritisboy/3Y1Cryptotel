import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotel_flutter/presentation/widgets/home/card_widget.dart';
import 'package:hotel_flutter/presentation/screens/homeScreens/hotel_screen.dart';
import 'package:hotel_flutter/logic/bloc/hotel/hotel_bloc.dart';
import 'package:hotel_flutter/logic/bloc/hotel/hotel_event.dart';
import 'package:hotel_flutter/logic/bloc/hotel/hotel_state.dart';
import 'package:hotel_flutter/data/model/hotel/hotel_model.dart';
import 'package:hotel_flutter/presentation/widgets/shimmer_loading/card/shimmer_card.dart';

class HomeScreen extends StatelessWidget {
  final String searchQuery;
  final Axis scrollDirection;
  final String rowOrColumn;
  final double width;

  const HomeScreen(
      {super.key,
      required this.searchQuery,
      required this.scrollDirection,
      required this.rowOrColumn,
      required this.width});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HotelBloc(context.read())..add(FetchHotelsEvent()),
      child: BlocBuilder<HotelBloc, HotelState>(
        builder: (context, state) {
          if (state is HotelLoading) {
            return ShimmerCard(
              scrollDirection: scrollDirection,
            ); // Shimmer Effect
          } else if (state is HotelLoaded) {
            final filteredHotels = state.hotels
                .where((hotel) => hotel.name
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()))
                .toList();
            return _buildHotelList(context, filteredHotels);
          } else if (state is HotelError) {
            return Center(child: Text('Error: ${state.error}'));
          }
          return ShimmerCard(
            scrollDirection: scrollDirection,
          ); // Default shimmer
        },
      ),
    );
  }

  Widget _buildHotelList(BuildContext context, List<HotelModel> hotels) {
    final uniqueHotels = hotels.toSet().toList(); // Remove duplicate entries

    final children = uniqueHotels.map((hotel) {
      return Padding(
        padding: const EdgeInsets.only(left: 16, right: 20.0, bottom: 20),
        child: InkWell(
          onTap: () async {
            List<double> coordinates = await hotel.getCoordinates();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HotelScreen(
                  hotelId: hotel.id,
                  hotelImage: hotel.hotelImage,
                  hotelName: hotel.name,
                  rating: hotel.averageRating,
                  price: hotel.averagePrice,
                  location: hotel.location,
                  time: hotel.openingHours,
                  latitude: coordinates[0],
                  longitude: coordinates[1],
                ),
              ),
            );
          },
          child: CardWidget(
            imagePath: hotel.hotelImage,
            hotelName: hotel.name,
            location: hotel.location,
            rating: hotel.averageRating,
            width: width,
          ),
        ),
      );
    }).toList();

    if (rowOrColumn == 'row') {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: children),
      );
    } else {
      return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: children);
    }
  }
}
