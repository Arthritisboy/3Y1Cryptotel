import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotel_flutter/logic/bloc/restaurant/restaurant_bloc.dart';
import 'package:hotel_flutter/logic/bloc/restaurant/restaurant_state.dart';
import 'package:hotel_flutter/presentation/widgets/hotel/navigation/navigation_row.dart';
import 'package:hotel_flutter/presentation/widgets/restaurant/details/restaurant_details.dart';
import 'package:hotel_flutter/presentation/widgets/shimmer_loading/hotel/hotel_clicked.dart';
import 'package:hotel_flutter/logic/bloc/restaurant/restaurant_event.dart';

class RestaurantClicked extends StatefulWidget {
  final String restaurantId;
  final String restaurantName;
  final double rating;
  final double price;
  final String location;
  final String time;
  final int activeIndex;
  final Function(int) onNavTap;
  final double latitude;
  final double longitude;
  final String restaurantImage;
  final int capacity;

  const RestaurantClicked({
    super.key,
    required this.capacity,
    required this.restaurantId,
    required this.restaurantName,
    required this.rating,
    required this.price,
    required this.location,
    required this.time,
    required this.activeIndex,
    required this.onNavTap,
    required this.latitude,
    required this.longitude,
    required this.restaurantImage,
  });

  @override
  State<RestaurantClicked> createState() => _RestaurantClickedState();
}

class _RestaurantClickedState extends State<RestaurantClicked> {
  @override
  void initState() {
    super.initState();
    context
        .read<RestaurantBloc>()
        .add(FetchRestaurantDetailsEvent(widget.restaurantId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RestaurantBloc, RestaurantState>(
      builder: (context, state) {
        if (state is RestaurantLoading) {
          return const ShimmerHotelClicked();
        } else if (state is RestaurantError) {
          return Center(child: Text(state.error));
        } else if (state is RestaurantDetailsLoaded) {
          final filteredRatingList = state.restaurant.rating;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  child: Image.network(
                    widget.restaurantImage,
                    height: 300.0,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
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
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              widget.restaurantName,
                              style: const TextStyle(
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
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
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
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
                if (widget.activeIndex == 2)
                  RestaurantDetails(
                    capacity: widget.capacity,
                    restaurantName: widget.restaurantName,
                    rating: widget.rating,
                    price: widget.price,
                    location: widget.location,
                    time: widget.time,
                    latitude: widget.latitude,
                    longitude: widget.longitude,
                  ),
                if (widget.activeIndex == 3) Center(child: Text('Test'))
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
