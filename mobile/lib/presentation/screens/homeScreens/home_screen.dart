import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotel_flutter/presentation/widgets/home/card_widget.dart';
import 'package:hotel_flutter/presentation/screens/homeScreens/hotel_screen.dart';
import 'package:hotel_flutter/logic/bloc/hotel/hotel_bloc.dart';
import 'package:hotel_flutter/logic/bloc/hotel/hotel_event.dart';
import 'package:hotel_flutter/logic/bloc/hotel/hotel_state.dart';
import 'package:hotel_flutter/data/model/hotel/hotel_model.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HotelBloc(context.read())..add(FetchHotelsEvent()),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Top Rated Hotels',
                style: TextStyle(
                  fontSize: 24.0,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10.0),
              SizedBox(
                height: 270.0, // Constraint height for the horizontal scroll
                child: BlocBuilder<HotelBloc, HotelState>(
                  builder: (context, state) {
                    if (state is HotelLoading) {
                      return _buildShimmerLoadingEffect(); // Shimmer Effect
                    } else if (state is HotelLoaded) {
                      return _buildHotelList(context, state.hotels);
                    } else if (state is HotelError) {
                      return Center(child: Text('Error: ${state.error}'));
                    }
                    return const Center(child: Text('No data available'));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHotelList(BuildContext context, List<HotelModel> hotels) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: hotels.map((HotelModel hotel) {
          return Padding(
            padding: const EdgeInsets.only(right: 10.0),
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
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // Shimmer Loading Effect for Cards
  Widget _buildShimmerLoadingEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(3, (index) {
            return Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: SizedBox(
                width: 250.0,
                height: 240.0,
                child: Card(
                  elevation: 4.0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12.0),
                        ),
                        child: Container(
                          height: 130.0,
                          width: double.infinity,
                          color: Colors.white, // Placeholder for the image
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 140.0,
                              height: 20.0,
                              color: Colors.white, // Placeholder for hotel name
                            ),
                            const SizedBox(height: 4.0),
                            Row(
                              children: [
                                Container(
                                  width: 15.0,
                                  height: 15.0,
                                  color: Colors
                                      .white, // Placeholder for the place icon
                                ),
                                const SizedBox(width: 4.0),
                                Container(
                                  width: 100.0,
                                  height: 15.0,
                                  color: Colors
                                      .white, // Placeholder for location text
                                ),
                                const Spacer(),
                                Container(
                                  width: 60.0,
                                  height: 25.0,
                                  color: Colors.white, // Placeholder for rating
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
