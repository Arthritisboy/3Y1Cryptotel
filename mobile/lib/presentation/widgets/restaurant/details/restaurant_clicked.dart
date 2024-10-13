import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotel_flutter/logic/bloc/restaurant/restaurant_bloc.dart';
import 'package:hotel_flutter/logic/bloc/restaurant/restaurant_event.dart';
import 'package:hotel_flutter/logic/bloc/restaurant/restaurant_state.dart';
import 'package:hotel_flutter/presentation/widgets/restaurant/navigation/restaurant_navigation_row.dart';
import 'package:hotel_flutter/presentation/widgets/restaurant/details/restaurant_details.dart';
import 'package:hotel_flutter/presentation/widgets/restaurant/utils/restaurant_input_fields.dart';
import 'package:hotel_flutter/presentation/widgets/shimmer_loading/hotel/hotel_clicked.dart';
import 'package:hotel_flutter/presentation/widgets/restaurant/ratings/RestaurantRatingWidget.dart';

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
          print("Loaded restaurant: ${state.restaurant.name}");
          print("Ratings count: ${state.restaurant.ratings.length}");
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRestaurantImage(),
                const SizedBox(height: 10),
                _buildRestaurantInfo(),
                _buildNavigationRow(),
                if (widget.activeIndex == 0) _buildInputFields(),
                if (widget.activeIndex == 1) _buildRestaurantDetails(state),
                if (widget.activeIndex == 2)
                  Restaurantratingwidget(ratings: state.restaurant.ratings),
              ],
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Widget _buildRestaurantImage() {
    return ClipRRect(
      child: Image.network(
        widget.restaurantImage,
        height: 300.0,
        width: double.infinity,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const ShimmerHotelClicked();
        },
        errorBuilder: (context, error, stackTrace) {
          return const Center(
            child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
          );
        },
      ),
    );
  }

  Widget _buildRestaurantInfo() {
    return Padding(
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
          _buildRow(Icons.attach_money, '₱${widget.price} and over'),
          _buildRow(Icons.access_time, 'Open Hours: ${widget.time}'),
          _buildRow(Icons.location_on_outlined, widget.location),
          _buildRow(
              Icons.group_outlined, 'Capacity: ${widget.capacity} people'),
        ],
      ),
    );
  }

  Widget _buildRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 26, color: Colors.grey),
        const SizedBox(width: 8.0),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationRow() {
    return RestaurantNavigationRow(
      activeIndex: widget.activeIndex,
      onTap: widget.onNavTap,
      showBook: true,
    );
  }

  Widget _buildInputFields() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 16, right: 16, bottom: 10),
      child: RestaurantInputFields(
        restaurantId: widget.restaurantId,
        capacity: widget.capacity,
      ),
    );
  }

  Widget _buildRestaurantDetails(RestaurantState state) {
    return RestaurantDetails(
      capacity: widget.capacity,
      restaurantName: widget.restaurantName,
      rating: widget.rating,
      price: widget.price,
      location: widget.location,
      time: widget.time,
      latitude: widget.latitude,
      longitude: widget.longitude,
    );
  }
}
