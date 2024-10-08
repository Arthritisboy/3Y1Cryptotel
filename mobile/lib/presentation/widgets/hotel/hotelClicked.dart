import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotel_flutter/logic/bloc/hotel/hotel_bloc.dart';
import 'package:hotel_flutter/logic/bloc/hotel/hotel_state.dart';
import 'package:hotel_flutter/presentation/widgets/hotel/details/hotelDetails.dart';
import 'package:hotel_flutter/presentation/widgets/hotel/navigation_row.dart';
import 'package:hotel_flutter/presentation/widgets/hotel/ratings/hotelRatings.dart';
import 'package:hotel_flutter/logic/bloc/hotel/hotel_event.dart';
import 'package:hotel_flutter/presentation/widgets/hotel/room/roomSelection.dart';

class HotelClicked extends StatefulWidget {
  final String hotelId;
  final String hotelName;
  final double rating;
  final double price;
  final String location;
  final String time;
  final int activeIndex;
  final Function(int) onNavTap;
  final double latitude;
  final double longitude;
  final String hotelImage;

  const HotelClicked({
    super.key,
    required this.hotelId,
    required this.hotelName,
    required this.rating,
    required this.price,
    required this.location,
    required this.time,
    required this.activeIndex,
    required this.onNavTap,
    required this.latitude,
    required this.longitude,
    required this.hotelImage,
  });

  @override
  State<HotelClicked> createState() => _HotelClickedState();
}

class _HotelClickedState extends State<HotelClicked> {
  @override
  void initState() {
    super.initState();
    context
        .read<HotelBloc>()
        .add(FetchHotelDetailsEvent(widget.hotelId)); // Using hotelId
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HotelBloc, HotelState>(
      builder: (context, state) {
        if (state is HotelLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is HotelError) {
          return Center(child: Text(state.error));
        } else if (state is HotelDetailsLoaded) {
          final filteredRoomList =
              state.hotel.rooms; // Accessing rooms from hotel object
          final filteredRatingList =
              state.hotel.rooms.expand((room) => room.ratings).toList();
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Network Image as per the new logic
                ClipRRect(
                  child: Image.network(
                    widget.hotelImage,
                    height: 200.0,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child; // Image is fully loaded
                      }
                      return const Center(
                        child:
                            CircularProgressIndicator(), // Show loader while loading
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(
                          Icons.broken_image,
                          size: 50,
                          color: Colors.grey,
                        ), // Fallback if image URL fails
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.hotelName,
                            style: const TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5.0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6.0, vertical: 5.0),
                              color: const Color.fromARGB(255, 29, 53, 115),
                              child: Row(
                                children: [
                                  Text(
                                    widget.rating.toString(),
                                    style: const TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 4.0),
                                  const Icon(Icons.star, color: Colors.amber),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Icon(Icons.attach_money,
                              color: Color.fromARGB(255, 142, 142, 147),
                              size: 26),
                          const SizedBox(width: 8.0),
                          Text(
                            '₱${widget.price} and over',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: Color.fromARGB(255, 142, 142, 147),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          const Icon(Icons.access_time,
                              color: Color.fromARGB(255, 142, 142, 147),
                              size: 26),
                          const SizedBox(width: 8.0),
                          Text(
                            "Open Hours: ${widget.time}",
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: Color.fromARGB(255, 142, 142, 147),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            color: Color.fromARGB(255, 142, 142, 147),
                            size: 26,
                          ),
                          const SizedBox(width: 8.0),
                          Expanded(
                            // Wrap Text with Expanded to allow wrapping
                            child: Text(
                              widget.location,
                              style: const TextStyle(
                                color: Color.fromARGB(255, 142, 142, 147),
                                fontSize: 15,
                              ),
                              overflow: TextOverflow
                                  .ellipsis, // Add ellipsis if text is too long
                              maxLines:
                                  1, // Limit to 1 line to prevent overflow
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: NavigationRow(
                    activeIndex: widget.activeIndex,
                    onTap: widget.onNavTap,
                    showBook: false, // Hide the Book option
                  ),
                ),
                const Divider(
                    thickness: 2, color: Color.fromARGB(255, 142, 142, 147)),

                // Room selection or hotel details based on the active tab
                if (widget.activeIndex == 0)
                  RoomSelection(roomList: filteredRoomList),

                if (widget.activeIndex == 2)
                  HotelDetails(
                    hotelName: widget.hotelName,
                    rating: widget.rating,
                    price: widget.price,
                    location: widget.location,
                    time: widget.time,
                    latitude: widget.latitude,
                    longitude: widget.longitude,
                  ),
                if (widget.activeIndex == 3)
                  HotelRatingWidget(ratings: filteredRatingList),
              ],
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
